define env::variable($content) {
  if ! defined( Class["env"] ) {
    class { env: }
  }

  case $::osfamily {
    'RedHat': {
      concat::fragment { "env_var_$name_redhat_sh":
        target => '/etc/profile.d/puppet.sh',
        content => "export ${name}=${content}\n",
        order => 01,
      }

      concat::fragment { "env_var_$name_redhat_csh":
        target => '/etc/profile.d/puppet.csh',
        content => "setenv ${name} ${content}\n",
        order => 01,
      }
    }
    default: {
      case $::operatingsystem {
        'Gentoo': {
          concat::fragment { "env_var_$name_gentoo":
            target => "/etc/env.d/99puppet",
            content => "${name}=${content}\n",
            order => 01,
          }
        }
      }
    }
  }
}
