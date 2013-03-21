class env {
  case $::osfamily {
    'RedHat': {
      concat { [ '/etc/profile.d/puppet.sh', '/etc/profile.d/puppet.csh' ]: }

      concat::fragment { "env_header_redhat":
        target => [ '/etc/profile.d/puppet.sh', '/etc/profile.d/puppet.csh' ],
        content => "# Puppet manages this file\n",
        order => 01,
      }
    }
    default: {
      case $::operatingsystem {
        'Gentoo': {
          concat { '/etc/env.d/99puppet': }

          concat::fragment { "env_header_gentoo":
            target => "/etc/env.d/99puppet",
            content => "# Puppet manages this file\n",
            order => 01,
          }

          exec { "/usr/sbin/env-update":
            subscribe => File['/etc/env.d/99puppet'],
            refreshonly => true,
          }
        }
      }
    }
  }
}
