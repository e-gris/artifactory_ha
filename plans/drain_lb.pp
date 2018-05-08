plan artifactory_ha::drain_lb(
  TargetSpec $apps,
  TargetSpec $lb
) {
  $app_names = get_targets($apps).map |$t| { $t.host.split('[.]')[0] }
  $lb_names = get_targets($lb).map |$t| { $t.name }

  # Makes more sense as a task in Puppet using the puppetlabs-haproxy module
  notice("Draining ${app_names} on ${lb_names}")
  $app_names.each |$app| {
    $sed = "sed -i -e '/ *server *${app}/ s/^#*/#/'"
    run_command("${sed} /etc/haproxy/haproxy.cfg", $lb, _run_as => 'root')
  }
  run_command('systemctl restart haproxy', $lb, _run_as => 'root')
  undef
}
