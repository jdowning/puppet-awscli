# ==Class: awscli::deps
class awscli::deps {
  if ! defined(Package['python-dev']) {
    package { 'python-dev': ensure => installed }
  }

  if ! defined(Package['python-pip']) {
    package { 'python-pip': ensure => installed }
  }
}
