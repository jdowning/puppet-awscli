# == Class: awscli::deps::debian
#
# This module manages awscli dependencies for Debian $::osfamily.
#
class awscli::deps::debian {
  constraint {
    "python-dev-package":
      resource  => Package['python-dev'],
      allow     => { ensure => [ 'present' ] };
  }

  constraint {
    "python-pip-package":
      resource  => Package['python-pip'],
      allow     => { ensure => [ 'present' ] };
  }
}
