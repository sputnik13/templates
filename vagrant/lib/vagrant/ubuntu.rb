# -*- mode: ruby -*-
# vi: set ft=ruby :

# Common provisioning steps for Ubuntu VMs
$ubuntu_box = "sputnik13/trusty64"

def ubuntu_common(machine, vm_def)
  package_proxy = vm_def.has_key?('package_proxy') ? vm_def['package_proxy'] : $package_proxy
  install_tmate = vm_def.has_key?('install_tmate') ? vm_def['install_tmate'] : $install_tmate

  machine.vm.box = $ubuntu_box

  machine.vm.provision :shell, :privileged => true,
    :inline => "DEBIAN_FRONTEND=noninteractive apt-get update"
  machine.vm.provision :shell, :privileged => true,
    :inline => "DEBIAN_FRONTEND=noninteractive apt-get install --yes git"
  machine.vm.provision :shell, :privileged => true,
    :inline => "DEBIAN_FRONTEND=noninteractive apt-get install --yes python-software-properties software-properties-common squid-deb-proxy-client"

  if package_proxy
    machine.vm.provision :shell, :privileged => true,
      :inline => "echo \"Acquire { Retries \\\"0\\\"; HTTP { Proxy \\\"#{package_proxy}\\\"; }; };\" > /etc/apt/apt.conf.d/99proxy"
  end

  # Install tmate [optional]
  if install_tmate
    machine.vm.provision "shell", :inline => "sudo add-apt-repository ppa:nviennot/tmate"
    machine.vm.provision "shell", :inline => "sudo apt-get update"
    machine.vm.provision "shell", :inline => "sudo apt-get install -y tmate"
  end

  machine.vm.provision "shell", :inline => "sudo apt-get install -y git"

  # Remove anything unnecessary
  machine.vm.provision "shell", inline: "apt-get autoremove -y"
end
