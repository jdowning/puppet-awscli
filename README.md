# awscli

[![Puppet Forge](http://img.shields.io/puppetforge/v/jdowning/awscli.svg)](https://forge.puppetlabs.com/jdowning/awscli) [![Build Status](https://travis-ci.org/justindowning/puppet-awscli.png)](https://travis-ci.org/justindowning/puppet-awscli)

## Description

This Puppet module will install [awscli](https://github.com/aws/aws-cli). It is works with Debian/Ubuntu based distros. It should also work with RedHat/CentOS as long as the EPEL repository is available.

## Installation

`puppet module install --modulepath /path/to/puppet/modules jdowning-awscli`

## Usage

`class { 'awscli': }`

## Testing
You can test this module with rspec:

    bundle install
    bundle exec rake spec

## Vagrant

You can also test this module in a Vagrant box. There are two box definitons included in the
Vagrant file for CentOS and Ubuntu testing. You will need to use `librarian-puppet` to setup dependencies:

    bundle install
    bundle exec librarian-puppet install

To test both boxes:

    vagrant up

To test one distribution:

    vagrant up [centos|ubuntu]
