# -*- mode: ruby -*-

Vagrant.configure("2") do |config|
  config.vm.box = "bento/debian-8.6"
  config.vm.provision :salt do |salt|
    salt.minion_config = "vagrant/minion"
    salt.run_highstate = true
    salt.verbose = true
  end
end
