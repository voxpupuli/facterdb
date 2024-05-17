# Building Facts for distribution

There is `Vagrantfile` to automatically populate `facts` for all supported operating systems by spawning a new VM and launches a provisioning scripts.

## Vagrant

[Vagrant](https://www.vagrantup.com/) is a tool for creating reproducible virtual machine builds.
We use it to ensure facts are generated as similarly as possible every time.

Vagrant starts by downloading a `box` - a pre-build skeleton of a virtual machine - and then running multiple steps on it.
Our workflow generally looks like this:

1. One or more setup steps to make the VM ready to install puppet and generate facts (for example, setting up the network)
1. Calling the `get_facts` script which installs multiple versions of Puppet and generates facts for multiple versions of facter.
1. Shutting down the VM (Vagrant doesn't do this automatically).

### Plugins

The vagrant timezone plugin is recommended to prevent unnecessary changes to timezone facts:

```
vagrant plugin install vagrant-timezone
```

## Hypervisor

The distributed facts are built using [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
Building the facts will work with other visualization hosts, but will produce different results (eg. IP ranges) that will break spec tests.

VirtualBox versions 6 and 7 have been tested.
The GPLv3 version of VirtualBox is sufficient - the proprietary `Oracle VM VirtualBox Extension Pack` is not required.

## Building Facts

To build facts, specify an operating system or list of systems.

```
$ vagrant up --provision debian-11-x86_64
$ vagrant up --provision debian-11-x86_64 debian-12-x86_64 redhat-8-x86_64 redhat-9-x86_64
```

Windows systems are also available.

```
$ vagrant up --provision windows-server-2019-x86_64 windows-server-2022-x86_64 windows-10-x86_64 windows-11-x86_64
```

Once new facts are built, the table listing supported facter versions and operating systems needs to be updated.

```
$ bundle exec rake table
```

### Converted Facts

Not all facts can (or should) be built from VMs.
It often isn't necessary to run a separate VM to create some facts that won't be significantly different for existing facts.
Some operating systems are harder to run in VMs.

#### Create i386 facts from x86_64's ones

```
for file in facts/*/*-x86_64.facts; do cat $file | sed -e 's/x86_64/i386/' -e 's/amd64/i386/' > $(echo $file | sed 's/x86_64/i386/'); done
```

## Legacy Facts

*NOTE*: When using Facter version 4, by default some "legacy facts" are hidden from the output.
To generate a fact set with the legacy facts use the command `puppet facts show --show-legacy`

## OS-Specific Notes

### Ubuntu 18.04

The default Ubuntu 18.04 `box` creates a console log file (ubuntu-bionic-18.04-cloudimg-console.log).
Newer Ubuntu `boxes` don't do this.
This behavior can be modified by changing the `box` configuration: `config.vm.provider "virtualbox" do |vb|  vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"]  end`

### Windows

There are publicly available Windows `boxes` for Vagrant.

We currently use publicly-availble `boxes` from Vagrant Community, but we also included packer templates so you can build your own (currently outdated).

run `packer build <file>.json`
followed by `vagrant add <boxname> <boxfile>`

Once the box is added, change the `Vagrantfile` to use your new `box` and run `vagrant up <windows_os_name>`

