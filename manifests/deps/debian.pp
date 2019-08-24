# == Class: awscli::deps::debian
#
# This module manages awscli dependencies for Debian $::os['family'].
#
class awscli::deps::debian {
  if $awscli::install_pkgdeps {
    if ! defined(Package[ $awscli::pkg_dev ]) {
      package { $awscli::pkg_dev: ensure => installed }
    }
  }

  if $awscli::install_pip {
    if ! defined(Package[ $awscli::pkg_pip ]) {
      package { $awscli::pkg_pip: ensure => installed }
    }
  }
}
