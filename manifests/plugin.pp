#
#
define artifactory_ha::plugin(
  String $url,
  )
{
  File {
    owner => 'jfrog',
    group => 'jfrog',
    mode  => 'a+rx',
  }

  $file_name =  regsubst($url, '.+\/([^\/]+)$', '\1')

  file {"${::artifactory_ha::cluster_home}/ha-etc/plugins/${file_name}":
    ensure => file,
    source => $url,
    notify => Class['::artifactory::service'],
  }
}
