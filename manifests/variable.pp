define env::variable($content) {
  if ! defined( Class["env"] ) {
    class { env: }
  }

  case $::osfamily {
    'RedHat', 'Debian': {
      concat::fragment { "env_var_${name}_redhat_sh":
        target => '/etc/profile.d/puppet.sh',
        content => "export ${name}=${content}\n",
        order => 01,
      }

      concat::fragment { "env_var_${name}_redhat_csh":
        target => '/etc/profile.d/puppet.csh',
        content => "setenv ${name} ${content}\n",
        order => 01,
      }
    }
    default: {
      case $::operatingsystem {
        'Gentoo': {
          concat::fragment { "env_var_${name}_gentoo":
            target => "/etc/env.d/99puppet",
            content => "${name}=${content}\n",
            order => 01,
          }
        }
      }
    }
  }
}
