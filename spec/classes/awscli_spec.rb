require 'spec_helper'

describe 'awscli', :type => 'class' do
  context 'supported OS' do
    ['darwin', 'debian', 'redhat'].each do |osfamily|
      describe "#{osfamily} installation" do
        let(:facts) { { :osfamily => osfamily } }

        it { should contain_class("awscli::deps") }

        it do should contain_package('awscli').with(
          'ensure'   => 'present',
          'provider' => 'pip',
          'install_options' => nil,
        ) end
      end

      describe "proxy pip setup" do
        let(:facts) { { :osfamily => 'debian' } }
        let(:params) { { :install_options => ['--proxy foo'] } }

        it do should contain_package('awscli').with(
          'ensure'   => 'present',
          'provider' => 'pip',
          'install_options' => ['--proxy foo'],
        ) end
      end
    end
  end
end
