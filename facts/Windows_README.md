At the time of writing there are not suitable publicly available windows server
vagrant boxes that can be used to generate the facts.

In order to make fact collection reproducible, I have included packer templates
so boxes can be rebuilt.

run `packer build <file>.json`
followed by `vagrant add <boxname> <boxfile>`

Once the box is added a simple `vagrant up <windows_os_name>` will collect all the facts in the same manner as the unix based hosts.

