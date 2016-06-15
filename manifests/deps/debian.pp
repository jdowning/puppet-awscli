# == Class: awscli::deps::debian
#
# This module manages awscli dependencies for Debian $::osfamily.
#
class awscli::deps::debian {
  if $install_pkgdeps {
    if ! defined(Package[ $awscli::pkg_dev ]) {
      package { $awscli::pkg_dev: ensure => installed }
    }
  }

  if $install_pip {
    if ! defined(Package[ $awscli::pkg_pip ]) {
      package { $awscli::pkg_pip: ensure => installed }
    }
  }
}
