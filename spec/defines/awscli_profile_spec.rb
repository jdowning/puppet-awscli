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
          is_expected.to contain_file('/root/.aws').with_ensure('directory')
          is_expected.to contain_concat('/root/.aws/credentials')
          is_expected.to contain_concat__fragment( 'test_profile' ).with
          ({
            :target =>  '/root/.aws/credentials'
          })
        end

        it 'should create profile for user test' do
          params.merge!({
            'user'                  => 'test',
          })
          is_expected.to contain_file('/home/test/.aws').with_ensure('directory')
          is_expected.to contain_concat('/home/test/.aws/credentials')
          is_expected.to contain_concat__fragment( 'test_profile' ).with
          ({
            :target =>  '/home/test/.aws/credentials'
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
      is_expected.to contain_file('/Users/test/.aws').with_ensure('directory')
      is_expected.to contain_concat('/Users/test/.aws/credentials')
      is_expected.to contain_concat__fragment( 'test_profile' ).with
      ({
        :target =>  '/Users/test/.aws/credentials'
      })
    end
  end
end
