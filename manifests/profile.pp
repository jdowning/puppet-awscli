# == Define: awscli::profile
#
# Configures an aws-cli profile
#
# === Variables
#
# [$user]
#   The user for whom the profile will be installed
#
# [$group]
#   The group for whom the profile will be installed
#
# [$homedir]
#   The home directory where the config and credentials will be placed
#
# [$aws_access_key_id]
#   The aws_access_key_id for this profile. If not specified, aws-cli can
#   can use IAM roles to authenticate.
#
# [$aws_secret_access_key]
#   The aws_secret_access_key for this profile. If not specified, aws-cli can
#   can use IAM roles to authenticate.
#
# [$aws_region]
#   The aws_region for this profile
#   Default: us-east-1
#
# [$output]
#   The output format used for this profile
#   Default: json
#
# === Example
#
# awscli::profile { 'default':
#   user                  => 'tsmith',
#   aws_access_key_id     => 'access_key',
#   aws_secret_access_key => 'secret_key',
#   aws_region            => 'us-west-2',
#   output                => 'text',
# }
#
define awscli::profile(
  $user                  = 'root',
  $group                 = undef,
  $homedir               = undef,
  $aws_access_key_id     = undef,
  $aws_secret_access_key = undef,
  $aws_region            = 'us-east-1',
  $output                = 'json',
) {
  if $aws_access_key_id == undef and $aws_secret_access_key == undef {
    info ('AWS keys for awscli::profile. Your will need IAM roles configured.')
    $skip_credentials = true
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

  # ensure $homedir/.aws is available
  if !defined(File["${homedir_real}/.aws"]) {
    file { "${homedir_real}/.aws":
      ensure => 'directory',
      owner  => $user,
      group  => $group_real
    }
  }

  # setup credentials
  if ! $skip_credentials {
    if !defined(Concat["${homedir_real}/.aws/credentials"]) {
      concat { "${homedir_real}/.aws/credentials":
        ensure => 'present',
        owner  => $user,
        group  => $group_real
      }
    }

    concat::fragment { "${title}-credentials":
      target  => "${homedir_real}/.aws/credentials",
      content => template('awscli/credentials_concat.erb')
    }
  }

  # setup config
  if !defined(Concat["${homedir_real}/.aws/config"]) {
    concat { "${homedir_real}/.aws/config":
      ensure => 'present',
      owner  => $user,
      group  => $group_real
    }
  }

  concat::fragment { "${title}-config":
    target  => "${homedir_real}/.aws/config",
    content => template('awscli/config_concat.erb')
  }
}
