require 'spec_helper'

describe 'awscli', :type => 'class' do
  let(:facts) { { :osfamily => 'Debian' } }

  it { should contain_class('awscli::deps') }

  it do should contain_package('awscli').with(
    'ensure'   => 'latest',
    'provider' => 'pip',
  ) end
end
