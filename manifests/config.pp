# == Class artifactory::config
#
# This class is called from artifactory for service config.
#
class artifactory_ha::config {
  # Default file sould have artifactory owner and group
  File {
    owner => 'jfrog',
    group => 'jfrog',
  }

  file { "${::artifactory::artifactory_home}/etc/ha-node.properties":
    ensure  => file,
    content => epp(
      'artifactory_ha/ha-node.properties.epp',
      {
        cluster_home    => $::artifactory_ha::cluster_home,
        membership_port => $::artifactory_ha::membership_port,
        is_primary      => $::artifactory_ha::is_primary,
      }
    ),
    mode    => '0644',
  }

  file { "${::artifactory::artifactory_home}" }:
    ensure => directory,
  }
  
  file { "${::artifactory::artifactory_home}/etc}":
    ensure => directory,
  }

  # Configure cluster home
  file { $::artifactory_ha::cluster_home:
    ensure => directory,
  }

  file { "${::artifactory_ha::cluster_home}/etc":
    ensure => directory,
  }

  # Create the plugins directory
  file { "${::artifactory_ha::cluster_home}/etc/plugins":
    ensure  => directory,
  }

  # Setup cluster.properties
  #file { "${::artifactory_ha::cluster_home}/etc/cluster.properties":
  #  ensure  => file,
  #  content => "security.token=${::artifactory_ha::security_token}",
  #}

  file { "${::artifactory_ha::cluster_home}/etc/db.properties":
    ensure  => file,
    content => epp(
      'artifactory_ha/db.properties.epp',
      {
        db_url                         => $::artifactory_ha::db_url,
        db_username                    => $::artifactory_ha::db_username,
        db_password                    => $::artifactory_ha::db_password,
        db_type                        => $::artifactory_ha::db_type,
        binary_provider_type           => $::artifactory_ha::binary_provider_type,
        pool_max_active                => $::artifactory_ha::pool_max_active,
        pool_max_idle                  => $::artifactory_ha::pool_max_idle,
        binary_provider_cache_maxSize  => $::artifactory_ha::binary_provider_cache_maxSize,
        binary_provider_filesystem_dir => $::artifactory_ha::binary_provider_filesystem_dir,
        binary_provider_cache_dir      => $::artifactory_ha::binary_provider_cache_dir,
      }
    ),
    mode    => '0600',
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
    mode => '0755',
  }
}
