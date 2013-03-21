class environment {
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
            subscribe => File[$env],
            refreshonly => true,
          }
        }
      }
    }
  }
}

define environment::variable($content) {
  case $::osfamily {
    'RedHat': {
      concat::fragment { "env_var_$name_redhat_sh":
        target => '/etc/profile.d/puppet.sh',
        content => "export ${name}=${content}",
        order => 01,
      }

      concat::fragment { "env_var_$name_redhat_csh":
        target => '/etc/profile.d/puppet.csh',
        content => "setenv ${name} ${content}",
        order => 01,
      }
    }
    default: {
      case $::operatingsystem {
        'Gentoo': {
          concat::fragment { "env_var_$name_gentoo":
            target => "/etc/env.d/99puppet",
            content => "${name}=${content}",
            order => 01,
          }
        }
      }
    }
  }
}
