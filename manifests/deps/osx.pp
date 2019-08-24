# == Class: awscli::deps::osx
#
# This module manages awscli dependencies for Darwin $::os['family'].
#
class awscli::deps::osx {
  if $awscli::install_pkgdeps {
    if ! defined(Package[ $awscli::pkg_dev ]) {
      package { $awscli::pkg_dev: ensure => installed, provider => homebrew }
    }
  }
  if $awscli::install_pip {
    if ! defined(Package[ $awscli::pkg_pip ]) {
      package { $awscli::pkg_pip: ensure => installed, provider => homebrew }
    }
  }
}
