# == Class: awscli::deps::debian
#
# This module manages awscli dependencies for Debian $::osfamily.
#
class awscli::deps::debian {
  if ! defined(Package[ $awscli::pkg_dev ]) {
    package { $awscli::pkg_dev: ensure => installed }
  }
  if ! defined(Package[ $awscli::pkg_pip ]) {
    package { $awscli::pkg_pip: ensure => installed }
  }
}
