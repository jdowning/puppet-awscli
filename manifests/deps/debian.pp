# == Class: awscli::deps::debian
#
# This module manages awscli dependencies for Debian $::osfamily.
#
class awscli::deps::debian {
  constraint {
    "python-dev-package":
      resource  => Package['python-dev'],
      allow     => { ensure => ['installed', 'present', 'latest' ] },
      weak      => true;
  }

  constraint {
    "python-pip-package":
      resource  => Package['python-pip'],
      allow     => { ensure => ['installed', 'present', 'latest' ] },
      weak      => true;
  }

#  if ! defined(Package['python-dev']) {
#    package { 'python-dev': ensure => installed }
#  }
#  if ! defined(Package['python-pip']) {
#    package { 'python-pip': ensure => installed }
#  }
}
