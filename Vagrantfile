# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = 'puppet-awscli'
  config.vm.synced_folder ".", "/tmp/awscli"

  #config.vm.define "centos" do |centos|
  #  centos.vm.box     = 'centos64'
  #  centos.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box'
  #  centos.vm.provision :puppet do |puppet|
  #    puppet.manifests_path = "tests"
  #    puppet.manifest_file  = "vagrant.pp"
  #    puppet.options        = ["--modulepath", "/tmp"]
  #  end
  #end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box     = 'ubuntu64'
    ubuntu.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box'
    ubuntu.vm.provision :shell, :inline => 'aptitude update'
    ubuntu.vm.provision :puppet do |puppet|
      puppet.manifests_path = "tests"
      puppet.manifest_file  = "vagrant.pp"
      puppet.options        = ["--modulepath", "/tmp"]
    end
  end

end
