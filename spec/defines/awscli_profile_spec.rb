require 'spec_helper'

describe 'awscli::profile', :type => :define do
  context 'on supported operatingsystems' do
    [ 'darwin', 'debian', 'redhat'].each do |osfamily|
      describe "#{osfamily} installation" do
        let(:facts) { {
          :osfamily => osfamily,
          :concat_basedir => '/var/lib/puppet/concat/'
        } }

        let(:title) { 'test_profile' }

        let(:params) { { } }

        it 'should report an error if no aws_access_key_id is given' do
          is_expected.to raise_error(Puppet::Error, /no aws_access_key_id provided/)
        end

        it 'should report an error if no aws_secret_access_key is given' do
          params.merge!({ 'aws_access_key_id' => 'TESTAWSACCESSKEYID' })
          is_expected.to raise_error(Puppet::Error, /no aws_secret_access_key provided/)
        end
      end
    end
  end

  context 'on supported Linux distributions' do
    [ 'debian', 'redhat'].each do |osfamily|
      describe "#{osfamily} installation" do
        let(:facts) { {
          :osfamily => osfamily,
          :concat_basedir => '/var/lib/puppet/concat/'
        } }

        let(:title) { 'test_profile' }

        let(:params) { {
          'aws_access_key_id'     => 'TESTAWSACCESSKEYID',
          'aws_secret_access_key' => 'TESTSECRETACCESSKEY'
        } }

        it 'should create profile for root if no user is given' do
          is_expected.to contain_file('/root/.aws').with(
          {
            :ensure => 'directory',
            :owner  => 'root',
            :group  => 'root'
          })
          is_expected.to contain_concat('/root/.aws/credentials').with(
          {
            :owner  => 'root',
            :group  => 'root'
          })
          is_expected.to contain_concat__fragment( 'credential-file-append' ).with(
          {
            :target =>  '/root/.aws/credentials'
          })
        end

        it 'should create profile for user test' do
          params.merge!({
            'user'                  => 'test',
          })
          is_expected.to contain_file('/home/test/.aws').with(
          {
            :ensure => 'directory',
            :owner  => 'test',
            :group  => 'test'
          })
          is_expected.to contain_concat('/home/test/.aws/credentials').with(
          {
            :owner  => 'test',
            :group  => 'test'
          })
          is_expected.to contain_concat__fragment( 'credential-file-append' ).with(
          {
            :target =>  '/home/test/.aws/credentials'
          })

          is_expected.to_not contain_concat('/home/test/.aws/config').with(
          {
            :owner  => 'test',
            :group  => 'test'
          })
          is_expected.to_not contain_concat__fragment( 'config-file-append' ).with(
          {
            :target =>  '/home/test/.aws/config'
          })
        end

        it 'should create profile for user test with region' do
          params.merge!({
            'user'                  => 'test',
            'aws_region'            => 'test',
          })
          is_expected.to contain_concat('/home/test/.aws/config').with(
          {
            :owner  => 'test',
            :group  => 'test'
          })
          is_expected.to contain_concat__fragment( 'config-file-append' ).with(
          {
            :target =>  '/home/test/.aws/config'
          })
        end

        it 'should create profile for user test with homedir /tmp' do
          params.merge!({
            'user'    => 'test',
            'homedir' => '/tmp'      
          })
          is_expected.to contain_file('/tmp/.aws')
          is_expected.to contain_concat('/tmp/.aws/credentials')
          is_expected.to contain_concat__fragment( 'credential-file-append' ).with(
          {
            :target =>  '/tmp/.aws/credentials'
          })
        end
      end
    end
  end

  context 'on Darwin' do
    let(:facts) { {
      :osfamily => 'Darwin',
      :concat_basedir => '/var/lib/puppet/concat/'
    } }

    let(:title) { 'test_profile' }

    let(:params) { {
        'user'                  => 'test',
        'aws_access_key_id'     => 'TESTAWSACCESSKEYID',
        'aws_secret_access_key' => 'TESTSECRETACCESSKEY'
    } }

    it 'should create profile for user test' do
      is_expected.to contain_file('/Users/test/.aws').with(
      {
        :ensure => 'directory',
        :owner  => 'test',
        :group  => 'staff'
      })
      is_expected.to contain_concat('/Users/test/.aws/credentials').with(
      {
        :owner  => 'test',
        :group  => 'staff'
      })
      is_expected.to contain_concat__fragment( 'credential-file-append' ).with(
      {
        :target =>  '/Users/test/.aws/credentials'
      })
    end
    it 'should create profile for user test with homedir /tmp' do
      params.merge!({
        'user'    => 'test',
        'homedir' => '/tmp'      
      })
      is_expected.to contain_file('/tmp/.aws')
      is_expected.to contain_concat('/tmp/.aws/credentials')
      is_expected.to contain_concat__fragment( 'credential-file-append' ).with(
      {
        :target =>  '/tmp/.aws/credentials'
      })
    end
  end
end
