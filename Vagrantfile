# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.6.0"

CONFIG = File.join(File.dirname(__FILE__), "vagrant_config.rb")


# Defaults for config options
$vm_count = 1
$hostname = File.basename(File.dirname(__FILE__)).delete('^A-Za-z0-9')
$domain = "localdomain"
$ip_prefix="10.250.251"
$vm_memory = 512
$vm_cpus = 1

# Overrides from config file
if File.exist?(CONFIG)
  require CONFIG
end

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = false
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = $vm_memory
    v.cpus = $vm_cpus
  end

  config.vm.provider "vmware_fusion" do |v, override|
    v.vmx["memsize"] = $vm_memory
    v.vmx["numvcpus"] = $vm_cpus
    v.vmx["vhv.enable"] = TRUE
    v.vmx["ethernet0.virtualdev"] = "vmxnet3"
    override.vm.box = "sputnik13/trusty64"
  end

  (1..$vm_count).each do |i|
    config.vm.define "#{$hostname}#{i}" do |node|
      node.vm.hostname = "#{$hostname}#{i}"
      node.vm.network :private_network, ip: "#{$ip_prefix}.#{100+i}", :netmask => "255.255.255.0"
      node.hostmanager.aliases = ["#{$hostname}#{i}.#{$domain}", "#{$hostname}#{i}"]
    end
  end
end
