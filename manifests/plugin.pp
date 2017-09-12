#
#
define artifactory_ha::plugin(String $url) { }

### Probably obsolete

  # File {
  #   owner => 'artifactory',
  #   group => 'artifactory',
  #   mode  => 'a+rx',
  # }

  # $file_name =  regsubst($url, '.+\/([^\/]+)$', '\1')

  # file {"${::artifactory_ha::cluster_home}/ha-etc/plugins/${file_name}":
  #   ensure => file,
  #   source => $url,
  #   notify => Class['::artifactory::service'],
  # }

