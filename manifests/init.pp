# == Class: awscli
#
# Install awscli
#
# === Parameters
#
#  package_ensure - Provides ability to change the version of awscli being installed.
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
class awscli (
  $package_ensure = 'latest'
) {
  include awscli::deps

  package { 'awscli':
    ensure   => $package_ensure,
    provider => 'pip',
    require  => Class['awscli::deps'],
  }
}
