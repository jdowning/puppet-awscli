# == Class: awscli::deps::redhat
#
# This module manages awscli dependencies for redhat $::osfamily.
#
class awscli::deps::redhat {
  include ::epel
  Package { require => Class['epel'] }

  if ! defined(Package[ $awscli::pkg_dev ]) {
    package { $awscli::pkg_dev: ensure => installed }
  }
  if ! defined(Package[ $awscli::pkg_pip ]) {
    package { $awscli::pkg_pip: ensure => installed }
  }
}
