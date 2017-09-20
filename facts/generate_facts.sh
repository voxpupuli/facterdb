#!/bin/sh
# This is a small script to spin up machines individuly as 
# i dont have the disk space for them all
awk '$1=="config.vm.define" {print $2 }' Vagrantfile | tr -d '"' | while read BOX
do
  echo "getting facts for ${BOX}"
  vagrant up ${BOX}
  vagrant destroy -f ${BOX}
done
