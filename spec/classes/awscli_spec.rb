require 'spec_helper'

describe 'awscli', type: 'class' do
  context 'supported OS' do
    ['darwin', 'debian', 'redhat'].each do |osfamily|
      describe "#{osfamily} installation" do
        let(:facts) do
          {
            os: {
              family: osfamily.to_s,
              release: 6,
            },
          }
        end

        it { is_expected.to contain_class('awscli::deps') }

        it do
          is_expected.to contain_package('awscli').with(
            'ensure'   => 'present',
            'provider' => 'pip',
            'install_options' => nil,
          )
        end
      end

      describe 'proxy pip setup' do
        let(:facts) do
          {
            os: {
              family: osfamily.to_s,
              release: 6,
            },
          }
        end
        let(:params) { { install_options: ['--proxy foo'] } }

        it do
          is_expected.to contain_package('awscli').with(
            'ensure'   => 'present',
            'provider' => 'pip',
            'install_options' => ['--proxy foo'],
          )
        end
      end
    end
  end
end
