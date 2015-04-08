class { 'awscli': version => 'latest' }
awscli::profile { 'default':
  user                  => 'vagrant',
  aws_access_key_id     => 'MYTESTACCESSKEYID',
  aws_secret_access_key => 'MYTESTSECRETACCESSKEY'
}
