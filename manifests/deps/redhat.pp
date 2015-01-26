# == Class: awscli::deps::redhat
#
# This module manages awscli dependencies for redhat $::osfamily.
#
class awscli::deps::redhat {
  include ::epel
  Package { require => Class['epel'] }

  if ! defined(Package['python-devel']) {
    package { 'python-devel': ensure => installed }
  }
  if ! defined(Package['python-pip']) {
    package { 'python-pip': ensure => installed }
  }
}
