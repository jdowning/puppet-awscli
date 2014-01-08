# == Class: awscli
#
# Install awscli
#
# === Parameters
#
#  None
#
# === Variables
#
#  None
#
# === Examples
#
#  class { awscli: }
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
# === Copyright
#
# Copyright 2014 Justin Downing
#
class awscli {
  include awscli::deps

  package { 'awscli':
    ensure   => 'latest',
    provider => 'pip',
    require  => Class['awscli::deps'],
  }
}
