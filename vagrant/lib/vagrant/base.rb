# -*- mode: ruby -*-
# vi: set ft=ruby :

CONFIG = File.join(File.dirname(__FILE__), "../../vagrant_config.rb")
DEFAULTS = File.join(File.dirname(__FILE__), "defaults.rb")
UBUNTU_COMMON = File.join(File.dirname(__FILE__), "ubuntu.rb")
FEDORA_COMMON = File.join(File.dirname(__FILE__), "fedora.rb")

require DEFAULTS
require UBUNTU_COMMON
require FEDORA_COMMON

def default_vm_list(count)
  vm_list = []

  (1..count).each do |i|
    vm_def = {
      'flavor' => $default_flavor,
      'hostname' => "#{$hostname}#{i}",
      'forwarded_ports' => $forwarded_ports,
      'package_proxy' => $package_proxy,
      'install_tmate' => $install_tmate,
      'memory' => $vm_memory,
      'cpus' => $vm_cpus,
    }
    vm_list.push(vm_def)
  end

  return vm_list
end

def define_vm(vagrant_config, vm_def)
  flavor = vm_def.has_key?('flavor') ? vm_def['flavor'] : $default_flavor
  hostname = vm_def.has_key?('hostname') ? vm_def['hostname'] : $hostname
  forwarded_ports = vm_def.has_key?('forwarded_ports') ? vm_def['forwarded_ports'] : $forwarded_ports
  #memory = vm_def.has_key?('memory') ? vm_def['memory'] : $memory
  #cpus = vm_def.has_key?('cpus') ? vm_def['cpus'] : $cpus

  vagrant_config.vm.define "#{hostname}" do |node|
    if flavor == "ubuntu"
      ubuntu_common(node, vm_def)
    elsif flavor == "fedora"
      fedora_common(node, vm_def)
    end

    #node.memory = memory
    #node.cpus = cpus

    node.vm.hostname = hostname
    forwarded_ports.each do |guest_port, host_port|
      node.vm.network "forwarded_port", guest: guest_port, host: host_port
    end
  end
end

def set_provider_options(config)
  config.vm.provider "virtualbox" do |v|
    v.memory = $vm_memory
    v.cpus = $vm_cpus
  end

  config.vm.provider "vmware_fusion" do |v, override|
    v.vmx["memsize"] = $vm_memory
    v.vmx["numvcpus"] = $vm_cpus
    v.vmx["vhv.enable"] = TRUE
    v.vmx["ethernet0.virtualdev"] = "vmxnet3"
  end
end

def set_plugin_options(config)
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = false
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
  end
end

if File.exist?(CONFIG)
  require CONFIG
end

