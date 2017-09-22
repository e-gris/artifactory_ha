class artifactory_ha(
  String $jdbc_driver_url,
  Enum['mssql', 'mysql', 'oracle', 'postgresql'] $db_type,
  String $db_url,
  String $db_username,
  String $db_password,
  String $artifactory_ha_data_dir,
  String $artifactory_ha_backup_dir,
  Boolean $is_primary,
  String $license_file,
  Integer $membership_port = 10001,
  String $yum_name = 'bintray-jfrog-artifactory-pro-rpms',
  String $yum_baseurl = 'http://jfrog.bintray.com/artifactory-pro-rpms',
  String $package_name = 'jfrog-artifactory-pro',
  Optional[String] $artifactory_etc = "/etc/opt/jfrog/artifactory",
  Optional[String] $artifactory_group = "artifactory",
  Optional[String] $artifactory_home = "/var/opt/jfrog/artifactory",
  Optional[String] $artifactory_user = "artifactory",
  Optional[String] $bootstrap_bundle = undef,
  Optional[String] $package_version = undef,
) {

  class {'::artifactory_pro':
    artifactory_etc   => $artifactory_etc,
    artifactory_group => $artifactory_group,
    artifactory_home  => $artifactory_home,
    artifactory_user  => $artifactory_user,
    db_password       => $db_password,
    db_type           => $db_type,
    db_url            => $db_url,
    db_username       => $db_username,
    is_primary        => $is_primary,
    jdbc_driver_url   => $jdbc_driver_url,
    license_file      => $license_file,
    package_name      => $package_name,
    package_version   => $package_version,
    yum_baseurl       => $yum_baseurl,
    yum_name          => $yum_name,
  } ->
  class{'::artifactory_ha::config': }

  # Ensure Artifactory Pro is configured before Artifactory HA.
  Class['::artifactory_pro::config'] ->
  Class['::artifactory_ha::config']  ~>
  Class['::artifactory::service']
}
