# == Define: awscli::profile
#
# Configures an aws-cli profile
#
# === Variables
#
# [$ensure]
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
# [$role_arn]
#   The ARN for the role to use in this profile. The source_profile must
#   be supplied when role_arn is specified
#
# [$source_profile]
#   The profile to use for credentials to assume the specified role
#
# [credential_source]
#   Used within EC2 instances or EC2 containers to specify where the AWS CLI can find credentials
#   to use to assume the role you specified with the role_arn parameter.
#   You cannot specify both source_profile and credential_source in the same profile.
#
# [$role_session_name]
#   An identifier for the assumed role session
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
#   role_arn              => 'arn:aws:iam::123456789012:role/MyRole',
#   source_profile        => 'user',
#   role_session_name     => 'mysession',
#   profile_name          => 'default',
#   output                => 'text',
# }
#
define awscli::profile(
  $ensure                                                                                 = 'present',
  $user                                                                                   = 'root',
  $group                                                                                  = undef,
  $homedir                                                                                = undef,
  $aws_access_key_id                                                                      = undef,
  $aws_secret_access_key                                                                  = undef,
  $role_arn                                                                               = undef,
  $source_profile                                                                         = undef,
  Optional[Enum['Environment', 'Ec2InstanceMetadata', 'EcsContainer']] $credential_source = undef,
  $role_session_name                                                                      = undef,
  $aws_region                                                                             = 'us-east-1',
  $profile_name                                                                           = 'default',
  $output                                                                                = 'json',
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
      $homedir_real = $::os['family']? {
        'Darwin' => "/Users/${user}",
        default  => "/home/${user}"
      }
    } else {
      $homedir_real = '/root'
    }
  }

  if ($group == undef) {
    if $user != 'root' {
      $group_real = $::os['family']? {
        'Darwin' => 'staff',
        default  => $user
      }
    } else {
      $group_real = 'root'
    }
  } else {
    $group_real = $group
  }

  if ($source_profile != undef and $credential_source != undef) {
    fail('aws cli profile cannot contain both source_profile and credential_source config option')
  }

  # ensure $homedir/.aws is available
  if !defined(File["${homedir_real}/.aws"]) {
    file { "${homedir_real}/.aws":
      ensure => 'directory',
      owner  => $user,
      group  => $group_real,
      mode   => '0700',
    }
  }

  # setup credentials
  if ! $skip_credentials {
    if !defined(Concat["${homedir_real}/.aws/credentials"]) {
      concat { "${homedir_real}/.aws/credentials":
        ensure    => 'present',
        owner     => $user,
        group     => $group_real,
        mode      => '0600',
        show_diff => false,
        require   => File["${homedir_real}/.aws"],
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
      mode    => '0600',
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
