# == Class: awscli::deps::redhat
#
# This module manages awscli dependencies for redhat $::os['family'].
#
class awscli::deps::redhat (
  $proxy        = $awscli::params::proxy,
  $manage_epel  = $awscli::manage_epel,
) inherits awscli::params {
  # Check if we manage epel repositories
  if $manage_epel {
    # Check if we have a proxy to setup with EPEL
    if $proxy != undef {
      class { '::epel':
        epel_proxy => $proxy,
      }
    }
    else {
      include ::epel
    }

    Package { require => Class['epel'] }
  }
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
