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
    default:  { fail('The wal_e module currently only suports Debian and RedHat families') }
  }
}
