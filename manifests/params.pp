# == Class: awscli::params
#
# This class manages awscli parameters depending on the platform and 
# should *not* be called directly.
#
class awscli::params {
    case $::osfamily {
      'Debian': {
        $pkg_dev = 'python-dev'
        $pkg_pip = 'python-pip'
      }
      'RedHat': {
        $pkg_dev = 'python-devel'
        $pkg_pip = 'python-pip'
      }
      'Darwin': {
        $pkg_dev = 'python'
        $pkg_pip = 'brew-pip'
      }
      default:  { fail("The awscli module does not support ${::osfamily}") }
    }
}
