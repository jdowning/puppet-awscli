# == Define: awscli::profile
#
# Puts a profile into the awscred file
#
# === Options
#
# [*aws_access_key_id*]
#    The aws_access_key_id for this profile
#
# [*aws_secret_access_key*]
#    The aws_secret_access_key for this profile
#
define awscli::profile(
  $user                  = 'root',
  $aws_access_key_id     = undef,
  $aws_secret_access_key = undef,
) {
  if $aws_access_key_id == undef {
    fail ('no aws_access_key_id provided')
  }

  if $aws_secret_access_key == undef {
    fail ('no aws_secret_access_key provided')
  }

  if $user != 'root' {
    $homedir = "/home/$user"
  } else {
    $homedir = "/root"
  }

  if !defined(File["homedir/.aws"]) {
    file { "$homedir/.aws":
      ensure => 'directory'
    }
  }

  if !defined(Concat["$homedir/.aws/credentials"]) {
    concat { "$homedir/.aws/credentials":
      ensure => 'present'
    }
  }


  concat::fragment{ "$title":
    target  => "$homedir/.aws/credentials",
    content => "[$title]\naws_access_key_id=$aws_access_key_id\naws_secret_access_key=$aws_secret_access_key\n\n",
  }
}


