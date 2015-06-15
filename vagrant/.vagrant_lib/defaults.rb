# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Set $hostname to specify an explicit hostname for the VM
$hostname = File.basename(File.expand_path(File.join(File.dirname(__FILE__),"../.."))).delete('^A-Za-z0-9')

$vm_count = 1

$default_flavor = 'ubuntu'

# Setup a guest port => host port mapping for the mappings provided below
$forwarded_ports = {}

# Ubuntu box
$ubuntu_box = "sputnik13/trusty64"

# Fedora box
$fedora_box = "box-cutter/fedora20"

# Specify a proxy to be used for packages
$package_proxy = nil

# Set $install_tmate to true to
$install_tmate = false

# Set the amount of RAM configured for the VM
$vm_memory = 4096

# Set the number of CPU cores configured for the VM
$vm_cpus = 2
