# == Class: awscli
#
# Install awscli
#
# === Parameters
#
#  [$version]
#    Provides ability to change the version of awscli being installed.
#    Default: 'latest'
#    This variable is required.
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
  $version = 'latest'
) {
  include awscli::deps

  package { 'awscli':
    ensure   => $version,
    provider => 'pip',
    require  => Class['awscli::deps'],
  }
}
