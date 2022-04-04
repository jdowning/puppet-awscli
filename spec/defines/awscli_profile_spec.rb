require 'spec_helper'

describe 'awscli::profile', type: :define do
  context 'on supported operatingsystems' do
    ['darwin', 'debian', 'redhat'].each do |osfamily|
      describe "#{osfamily} installation" do
        let(:facts) do
          {
            os: { family: osfamily.to_s },
            concat_basedir: '/var/lib/puppet/concat/',
          }
        end
        let(:title) { 'test_profile' }
        let(:params) { {} }

        it 'creates profile for root if no user is given' do
          is_expected.to contain_file('/root/.aws').with(
            ensure: 'directory',
            owner: 'root',
            group: 'root',
            mode: '0700',
          )
          is_expected.to contain_concat('/root/.aws/config').with(
            owner: 'root',
            group: 'root',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-config').with(
            target: '/root/.aws/config',
          )
        end
      end
    end
  end

  context 'on supported Linux distributions' do
    ['debian', 'redhat'].each do |osfamily|
      describe "#{osfamily} installation" do
        let(:facts) do
          {
            os: { family: osfamily.to_s },
            concat_basedir: '/var/lib/puppet/concat/',
          }
        end
        let(:title) { 'test_profile' }
        let(:params) do
          {
            'aws_access_key_id' => 'TESTAWSACCESSKEYID',
            'aws_secret_access_key' => 'TESTSECRETACCESSKEY',
          }
        end

        it 'creates profile for root if no user is given' do
          is_expected.to contain_file('/root/.aws').with(
            ensure: 'directory',
            owner: 'root',
            group: 'root',
            mode: '0700',
          )
          is_expected.to contain_concat('/root/.aws/config').with(
            owner: 'root',
            group: 'root',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-config').with(
            target: '/root/.aws/config',
          )
          is_expected.to contain_concat('/root/.aws/credentials').with(
            owner: 'root',
            group: 'root',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-credentials').with(
            target: '/root/.aws/credentials',
          )
        end

        it 'creates profile for user test' do
          params['user'] = 'test'
          is_expected.to contain_file('/home/test/.aws').with(
            ensure: 'directory',
            owner: 'test',
            group: 'test',
            mode: '0700',
          )
          is_expected.to contain_concat('/home/test/.aws/config').with(
            owner: 'test',
            group: 'test',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-config').with(
            target: '/home/test/.aws/config',
          )
          is_expected.to contain_concat('/home/test/.aws/credentials').with(
            owner: 'test',
            group: 'test',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-credentials').with(
            target: '/home/test/.aws/credentials',
          )
        end

        it 'creates profile for user test and group testGroup' do
          params.merge!('user' => 'test',
                        'group' => 'testGroup')
          is_expected.to contain_file('/home/test/.aws').with(
            ensure: 'directory',
            owner: 'test',
            group: 'testGroup',
            mode: '0700',
          )
          is_expected.to contain_concat('/home/test/.aws/config').with(
            owner: 'test',
            group: 'testGroup',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-config').with(
            target: '/home/test/.aws/config',
          )
          is_expected.to contain_concat('/home/test/.aws/credentials').with(
            owner: 'test',
            group: 'testGroup',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-credentials').with(
            target: '/home/test/.aws/credentials',
          )
        end

        it 'creates profile for user test with homedir /tmp' do
          params.merge!('user' => 'test',
                        'homedir' => '/tmp')
          is_expected.to contain_file('/tmp/.aws').with(
            ensure: 'directory',
            owner: 'test',
            group: 'test',
            mode: '0700',
          )
          is_expected.to contain_concat('/tmp/.aws/config').with(
            owner: 'test',
            group: 'test',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-config').with(
            target: '/tmp/.aws/config',
          )
          is_expected.to contain_concat('/tmp/.aws/credentials').with(
            owner: 'test',
            group: 'test',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-credentials').with(
            target: '/tmp/.aws/credentials',
          )
        end

        it 'creates profile for user test with group testGroup with homedir /tmp' do
          params.merge!('user' => 'test',
                        'group'   => 'testGroup',
                        'homedir' => '/tmp')
          is_expected.to contain_file('/tmp/.aws').with(
            ensure: 'directory',
            owner: 'test',
            group: 'testGroup',
            mode: '0700',
          )
          is_expected.to contain_concat('/tmp/.aws/config').with(
            owner: 'test',
            group: 'testGroup',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-config').with(
            target: '/tmp/.aws/config',
          )
          is_expected.to contain_concat('/tmp/.aws/credentials').with(
            owner: 'test',
            group: 'testGroup',
            mode: '0600',
          )
          is_expected.to contain_concat__fragment('test_profile-credentials').with(
            target: '/tmp/.aws/credentials',
          )
        end
      end
    end
  end

  context 'on Darwin' do
    let(:facts) do
      {
        os: { family: 'Darwin' },
        concat_basedir: '/var/lib/puppet/concat/',
      }
    end

    let(:title) { 'test_profile' }

    let(:params) do
      {
        'user' => 'test',
        'aws_access_key_id'     => 'TESTAWSACCESSKEYID',
        'aws_secret_access_key' => 'TESTSECRETACCESSKEY',
      }
    end

    it 'creates profile for user test' do
      is_expected.to contain_file('/Users/test/.aws').with(
        ensure: 'directory',
        owner: 'test',
        group: 'staff',
        mode: '0700',
      )
      is_expected.to contain_concat('/Users/test/.aws/config').with(
        owner: 'test',
        group: 'staff',
        mode: '0600',
      )
      is_expected.to contain_concat__fragment('test_profile-config').with(
        target: '/Users/test/.aws/config',
      )
      is_expected.to contain_concat('/Users/test/.aws/credentials').with(
        owner: 'test',
        group: 'staff',
        mode: '0600',
      )
      is_expected.to contain_concat__fragment('test_profile-credentials').with(
        target: '/Users/test/.aws/credentials',
      )
    end

    it 'creates profile for user test and group staff' do
      params['group'] = 'testGroup'
      is_expected.to contain_file('/Users/test/.aws').with(
        ensure: 'directory',
        owner: 'test',
        group: 'testGroup',
        mode: '0700',
      )
      is_expected.to contain_concat('/Users/test/.aws/config').with(
        owner: 'test',
        group: 'testGroup',
        mode: '0600',
      )
      is_expected.to contain_concat__fragment('test_profile-config').with(
        target: '/Users/test/.aws/config',
      )
      is_expected.to contain_concat('/Users/test/.aws/credentials').with(
        owner: 'test',
        group: 'testGroup',
        mode: '0600',
      )
      is_expected.to contain_concat__fragment('test_profile-credentials').with(
        target: '/Users/test/.aws/credentials',
      )
    end

    it 'creates profile for user test with homedir /tmp' do
      params.merge!('user' => 'test',
                    'homedir' => '/tmp')
      is_expected.to contain_file('/tmp/.aws').with(
        ensure: 'directory',
        owner: 'test',
        group: 'staff',
        mode: '0700',
      )
      is_expected.to contain_concat('/tmp/.aws/config').with(
        owner: 'test',
        group: 'staff',
        mode: '0600',
      )
      is_expected.to contain_concat__fragment('test_profile-config').with(
        target: '/tmp/.aws/config',
      )
      is_expected.to contain_concat('/tmp/.aws/credentials').with(
        owner: 'test',
        group: 'staff',
        mode: '0600',
      )
      is_expected.to contain_concat__fragment('test_profile-credentials').with(
        target: '/tmp/.aws/credentials',
      )
    end

    it 'creates profile for user test with group staff with homedir /tmp' do
      params.merge!('user' => 'test',
                    'group'   => 'testGroup',
                    'homedir' => '/tmp')
      is_expected.to contain_file('/tmp/.aws').with(
        ensure: 'directory',
        owner: 'test',
        group: 'testGroup',
        mode: '0700',
      )
      is_expected.to contain_concat('/tmp/.aws/config').with(
        owner: 'test',
        group: 'testGroup',
        mode: '0600',
      )
      is_expected.to contain_concat__fragment('test_profile-config').with(
        target: '/tmp/.aws/config',
      )
      is_expected.to contain_concat('/tmp/.aws/credentials').with(
        owner: 'test',
        group: 'testGroup',
        mode: '0600',
      )
      is_expected.to contain_concat__fragment('test_profile-credentials').with(
        target: '/tmp/.aws/credentials',
      )
    end
  end

  context 'on AWS Node' do
    let(:facts) do
      {
        os: { family: 'debian' },
        concat_basedir: '/var/lib/puppet/concat/',
      }
    end

    let(:title) { 'test_profile' }

    let(:params) do
      {
        'user' => 'test',
        'role_arn'     => 'TESTAWSROLEARN',
      }
    end

    ['Environment', 'Ec2InstanceMetadata', 'EcsContainer'].each do |source|
      it "creates profile for user test with credential_source=#{source}" do
        params['credential_source'] = source.to_s
        is_expected.to contain_file('/home/test/.aws').with(
          ensure: 'directory',
          owner: 'test',
          group: 'test',
          mode: '0700',
          )
        is_expected.to contain_concat('/home/test/.aws/config').with(
          owner: 'test',
          group: 'test',
          mode: '0600',
          )
        is_expected.to contain_concat__fragment('test_profile-config').with(
          target: '/home/test/.aws/config',
          )
      end
    end

    it "fails to create profile for user test with credential_source=Invalid" do
      params['credential_source'] = 'Invalid'
      is_expected.to compile.and_raise_error(/parameter 'credential_source' expects an undef value or a match for Enum/)
    end

    it 'fails to create profile with both source_profile and credential_source' do
      params['credential_source'] = 'Ec2InstanceMetadata'
      params['source_profile'] = 'development'
      is_expected.to compile.and_raise_error(/aws cli profile cannot contain both source_profile and credential_source config option/)
    end
  end
end
