# There is no need to declare `class { 'awscli': }` since the
# awscli package is already installed by default in Amazon Linux
awscli::profile { 'default':
  user                  => 'ec2-user',
  aws_access_key_id     => 'MYTESTACCESSKEYID',
  aws_secret_access_key => 'MYTESTSECRETACCESSKEY'
}
