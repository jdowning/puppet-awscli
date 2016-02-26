# == Class: awscli::deps::osx
#
# This module manages awscli dependencies for Darwin $::osfamily.
#
class awscli::deps::osx {
  if ! defined(Package[ $awscli::pkg_dev ]) {
    package { $awscli::pkg_dev: ensure => installed, provider => homebrew }
  }
  if ! defined(Package[ $awscli::pkg_pip ]) {
    package { $awscli::pkg_pip: ensure => installed, provider => homebrew }
  }
}
