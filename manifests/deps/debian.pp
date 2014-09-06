# ==Class: awscli::deps::debian
#
# This module manages awscli dependencies for Debian $::osfamily.
#
class awscli::deps::debian {
  if ! defined(Package['python-dev']) { package { 'python-dev': ensure => installed } }
  if ! defined(Package['python-pip']) { package { 'python-pip': ensure => installed } }
}
