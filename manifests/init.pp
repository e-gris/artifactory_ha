# Class: artifactory
# ===========================
#
# Full description of class artifactory here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#

class artifactory_ha(
  String $jdbc_driver_url,
  Enum['mssql', 'mysql', 'oracle', 'postgresql'] $db_type,
  String $db_url,
  String $db_username,
  String $db_password,
  String $artifactory_ha_data_dir,
  String $artifactory_ha_backup_dir,
  Boolean $is_primary,
  String $license_key,
  Integer $membership_port = 10001,
  String $yum_name = 'bintray-jfrog-artifactory-pro-rpms',
  String $yum_baseurl = 'http://jfrog.bintray.com/artifactory-pro-rpms',
  String $package_name = 'jfrog-artifactory-pro',
  Optional[Enum['filesystem', 'fullDb','cachedFS']] $binary_provider_type = undef,
  Optional[Integer] $pool_max_active = undef,
  Optional[Integer] $pool_max_idle = undef,
  Optional[Integer] $binary_provider_cache_maxSize = undef,
  Optional[String] $binary_provider_filesystem_dir = undef,
  Optional[String] $binary_provider_cache_dir = undef,
  Hash $plugin_urls = {},
) {

  class {'::artifactory_pro':
    license_key     => $license_key,
    yum_name        => $yum_name,
    yum_baseurl     => $yum_baseurl,
    package_name    => $package_name,
    jdbc_driver_url => $jdbc_driver_url,
    jdbc_driver_url => $jdbc_driver_url,
    db_type         => $db_type,
    db_url          => $db_url,
    db_username     => $db_username,
    db_password     => $db_password,
  } ->
  class{'::artifactory_ha::config': } ->
  class{'::artifactory_ha::post_config': }

  # Ensure Artifactory Pro is configured before Artifactory HA.
  Class['::artifactory_pro::config'] ->
  Class['::artifactory_ha::config']  ~>
  Class['::artifactory::service']

  Class['::artifactory_ha::post_config'] ~>
  Class['::artifactory::service']
}
