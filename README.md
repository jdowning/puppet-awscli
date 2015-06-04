# awscli

[![Puppet Forge](http://img.shields.io/puppetforge/v/jdowning/awscli.svg)](https://forge.puppetlabs.com/jdowning/awscli) [![Build Status](https://travis-ci.org/justindowning/puppet-awscli.png)](https://travis-ci.org/justindowning/puppet-awscli)

## Description

This Puppet module will install [awscli](https://github.com/aws/aws-cli). It is works with Debian, RedHat and OSX(Tested on Yosemite using boxen) based distros.

OSX has been tested on Yosemite only and requires:
- boxen https://boxen.github.com
- boxen homebrew https://github.com/boxen/puppet-homebrew.
- Packages python and brew-pip are require to be install using boxen. 

## Installation

`puppet module install --modulepath /path/to/puppet/modules jdowning-awscli`

## Usage

`class { 'awscli': }`

### Profiles

You may want to add a credentials for awscli and can do so using `awscli::profile`.
If you just define access_key_id and secret key, these credentials will work only for the root user:

```
awscli::profile { 'default':
  aws_access_key_id     => 'MYAWSACCESSKEYID',
  aws_secret_access_key => 'MYAWSSECRETACESSKEY'
}
```

You can also define a profile for a custom user:

```
awscli::profile { 'default':
  user                  => 'ubuntu',
  aws_access_key_id     => 'MYAWSACCESSKEYID',
  aws_secret_access_key => 'MYAWSSECRETACESSKEY'
}
```

If the user has a non-standard `${HOME}` location (`/home/${USER}` on Linux,
`/Users/${USER}` on Mac OS X), you can specify the homedir explicitly:

```
awscli::profile { 'default':
  user                  => 'ubuntu',
  homedir               => '/tmp',
  aws_access_key_id     => 'MYAWSACCESSKEYID',
  aws_secret_access_key => 'MYAWSSECRETACESSKEY'
}
```

You can also define the profile's region and output format:

```
awscli::profile { 'default':
  user                  => 'ubuntu',
  aws_access_key_id     => 'MYAWSACCESSKEYID',
  aws_secret_access_key => 'MYAWSSECRETACESSKEY'
  aws_region            => 'eu-west-1',
  output                => 'text',
}
```

If you do not provide `aws::profile::aws_access_key_id` and `awscli::profile::aws_secret_access_key`,
then the aws-cli tool can use IAM roles to authenticate a user's request.

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
