# ==Class: awscli::deps::osx
#
# This module manages awscli dependencies for Darwin $::osfamily.
#
class awscli::deps::osx {
  if ! defined(Package['python']) { package { 'python': ensure => installed, provider => homebrew } }
  if ! defined(Package['brew-pip']) { package { 'brew-pip': ensure => installed, provider => homebrew } }
}
