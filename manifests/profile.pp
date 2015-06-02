# == Define: awscli::profile
#
# Puts a profile into the awscred file
#
# === Options
#
# [*user*]
#    The user for whom the profile will be installed
# [*aws_access_key_id*]
#    The aws_access_key_id for this profile
#
# [*aws_secret_access_key*]
#    The aws_secret_access_key for this profile
#
define awscli::profile(
  $user                  = 'root',
  $group            = undef,
  $homedir               = undef,
  $aws_access_key_id     = undef,
  $aws_secret_access_key = undef,
  $aws_region            = undef,
) {
  if $aws_access_key_id == undef {
    fail ('no aws_access_key_id provided')
  }

  if $aws_secret_access_key == undef {
    fail ('no aws_secret_access_key provided')
  }

  if $homedir {
    $homedir_real = $homedir
  } else {
    if $user != 'root' {
      $homedir_real = $::osfamily? {
        'Darwin' => "/Users/${user}",
        default  => "/home/${user}"
      }
    } else {
      $homedir_real = '/root'
    }
  } 
  
  if ($group == undef) {
    if $user != 'root' {
      $group_real = $::osfamily? {
        'Darwin' => 'staff',
        default  => $user
      }
    } else {
      $group_real = 'root'
    }
  } else {
    $group_real = $group
  }

  if !defined(File["${homedir_real}/.aws"]) {
    file { "${homedir_real}/.aws":
      ensure => 'directory',
      owner  => $user,
      group  => $group_real
    }
  }

  if !defined(Concat["${homedir_real}/.aws/credentials"]) {
    concat { "${homedir_real}/.aws/credentials":
      ensure => 'present',
      owner  => $user,
      group  => $group_real
    }
  }

  concat::fragment{ "credential-file-append":
    target  => "${homedir_real}/.aws/credentials",
    content => template('awscli/credentials_concat.erb')
  }

  if $aws_region != undef {
    if !defined(Concat["${homedir_real}/.aws/config"]) {
      concat { "${homedir_real}/.aws/config":
        ensure => 'present',
        owner  => $user,
        group  => $group
      }
    }

    concat::fragment{ "config-file-append":
      target  => "${homedir_real}/.aws/config",
      content => template('awscli/config_concat.erb')
    }
  }
}
