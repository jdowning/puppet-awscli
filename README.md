# awscli

[![Build Status](https://travis-ci.org/justindowning/puppet-awscli.png)](https://travis-ci.org/justindowning/puppet-awscli)

## Description

This Puppet module will install [awscli](https://github.com/aws/aws-cli). It is works with Debian/Ubuntu based distros. It should also work with RedHat/CentOS as long as the EPEL repository is available.

## Installation

`puppet module install --modulepath /path/to/puppet/modules jdowning-awscli`

## Usage

`class { 'awscli': }`

## Testing

`vagrant up`
