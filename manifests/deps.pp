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
class awscli::deps {
  case $::osfamily {
    'Debian': {
      include awscli::deps::debian
    }
    'RedHat': {
      include awscli::deps::redhat
    }
    'Darwin': {
      include awscli::deps::osx
    }
    default:  { fail("The awscli module does not support ${::osfamily}") }
  }
}
