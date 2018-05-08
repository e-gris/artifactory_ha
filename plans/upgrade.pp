plan artifactory_ha::upgrade(
  TargetSpec $apps,
  TargetSpec $lb,
  String     $version
) {
  # Upgrade one at a time
  $app_targets = get_targets($apps)

  $app_targets.each |$app| {
    # TODO: disable puppet-agent
    run_plan(artifactory_ha::drain_lb, apps => $app, lb => $lb)

    $stop_result = run_task(service, $app, action => 'stop', service => 'artifactory', _catch_errors => true)
    if !$stop_result.ok {
      run_plan(artifactory_ha::restore_lb, apps => $app, lb => $lb)
      fail_plan("Failed to stop artifactory on ${app.name}")
    }

    $upgrade_result = run_task(package, $app, action => 'upgrade', name => 'jfrog-artifactory-pro', version => $version, _catch_errors => true)
    if !$upgrade_result.ok {
      run_plan(artifactory_ha::restore_lb, apps => $app, lb => $lb)
      fail_plan("Failed to upgrade artifactory on ${app.name}")
    }

    # Don't catch failure, as we wouldn't want to add it to the lb if the service isn't running.
    run_task(service, $app, action => 'start', service => 'artifactory')

    run_plan(artifactory_ha::restore_lb, apps => $app, lb => $lb)
    # TODO: enable puppet-agent

    # TODO: verify correct version is running
  }

  # TODO: verify service is accessible
}
