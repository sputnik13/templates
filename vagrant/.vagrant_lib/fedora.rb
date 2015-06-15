# -*- mode: ruby -*-
# vi: set ft=ruby :

# Common provisioning steps for Fedora VMs
$fedora_box = "box-cutter/fedora20"

def fedora_common(machine, vm_def)
  machine.vm.box = $fedora_box

  machine.vm.provision :shell, :privileged => true, :inline => "yum update -y vim-minimal" # RH Bug 1066983
  machine.vm.provision :shell, :privileged => true, :inline => "yum install -y git-core"
end
