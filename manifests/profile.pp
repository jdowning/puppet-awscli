# == Define: awscli::profile
#
# Configures an aws-cli profile
#
# === Variables
#
# [$ensure]
#
#   Control whether the profile should be present or not
#   Default: present
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
# [$profile_name]
#   The name of the AWS profile
#   Default: default
#
# [$output]
#   The output format used for this profile
#   Default: json
#
# === Example
#
# awscli::profile { 'tsmith-awscli':
#   user                  => 'tsmith',
#   aws_access_key_id     => 'access_key',
#   aws_secret_access_key => 'secret_key',
#   aws_region            => 'us-west-2',
#   profile_name          => 'default',
#   output                => 'text',
# }
#
define awscli::profile(
  $ensure                = 'present',
  $user                  = 'root',
  $group                 = undef,
  $homedir               = undef,
  $aws_access_key_id     = undef,
  $aws_secret_access_key = undef,
  $aws_region            = 'us-east-1',
  $profile_name          = 'default',
  $output                = 'json',
) {
  if $aws_access_key_id == undef and $aws_secret_access_key == undef {
    info ('AWS keys for awscli::profile. Your will need IAM roles configured.')
    $skip_credentials = true
  } else {
    $skip_credentials = false
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
      group  => $group_real,
    }
  }

  # setup credentials
  if ! $skip_credentials {
    if !defined(Concat["${homedir_real}/.aws/credentials"]) {
      concat { "${homedir_real}/.aws/credentials":
        ensure  => 'present',
        owner   => $user,
        group   => $group_real,
        mode    => '0600',
        require => File["${homedir_real}/.aws"],
      }
    }

    if ( $ensure == 'present' ) {
      concat::fragment { "${title}-credentials":
        target  => "${homedir_real}/.aws/credentials",
        content => template('awscli/credentials_concat.erb'),
      }
    }
  }

  # setup config
  if !defined(Concat["${homedir_real}/.aws/config"]) {
    concat { "${homedir_real}/.aws/config":
      ensure  => 'present',
      owner   => $user,
      group   => $group_real,
      require => File["${homedir_real}/.aws"],
    }
  }

  if ( $ensure == 'present' ) {
    concat::fragment { "${title}-config":
      target  => "${homedir_real}/.aws/config",
      content => template('awscli/config_concat.erb'),
    }
  }
}
