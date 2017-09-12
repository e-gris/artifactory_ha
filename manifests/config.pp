# == Class artifactory::config
#
# This class is called from artifactory for service config.
#
class artifactory_ha::config {
  # Default file should have artifactory owner and group
  File {
    owner => 'artifactory',
    group => 'artifactory',
  }

  file { "${::artifactory::artifactory_home}/etc/ha-node.properties":
    ensure  => file,
    content => epp(
      'artifactory_ha/ha-node.properties.epp',
      {
        artifactory_ha_data_dir   => $::artifactory_ha::artifactory_ha_data_dir,
        artifactory_ha_backup_dir => $::artifactory_ha::artifactory_ha_backup_dir,
        membership_port           => $::artifactory_ha::membership_port,
        is_primary                => $::artifactory_ha::is_primary,
      }
    ),
    mode    => '0644',
  }

  file { "${::artifactory_ha::cluster_home}/ha-data":
    ensure => directory,
  }

  file { "${::artifactory_ha::cluster_home}/ha-backup":
    ensure => directory,
  }

  $file_name =  regsubst($::artifactory_ha::jdbc_driver_url, '.+\/([^\/]+)$', '\1')

  ::wget::fetch { $::artifactory_ha::jdbc_driver_url:
    destination => "${::artifactory::artifactory_home}/tomcat/lib/",
  } ->
  file { "${::artifactory::artifactory_home}/tomcat/lib/${file_name}":
    mode => '0644',
  }
}
