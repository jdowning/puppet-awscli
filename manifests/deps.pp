# == Class: awscli::deps
#
# This module manages awscli dependencies and should *not* be called directly.
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
# === Copyright
#
# Copyright 2014 Justin Downing
#
class awscli::deps (
  $proxy = $awscli::params::proxy,
) inherits awscli::params {
  case $::osfamily {
    'Debian': {
      include awscli::deps::debian
    }
    'RedHat': {
      class { 'awscli::deps::redhat':
        proxy => $proxy,
      }
    }
    'Darwin': {
      include awscli::deps::osx
    }
    default:  { fail("The awscli module does not support ${::osfamily}") }
  }
}
