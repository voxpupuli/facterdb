#!/bin/sh
export PATH=/opt/puppetlabs/bin:$PATH

if test -f /usr/bin/apt-get; then
  apt-get update
  apt-get install -y lsb-release
  lsbdistcodename=$(lsb_release -sc)
  operatingsystem=$(lsb_release -si)
  operatingsystemmajrelease=$(lsb_release -sr)
  osfamily='Debian'
elif test -f /usr/bin/dnf; then
  operatingsystemmajrelease=$(awk '{print $3}' /etc/redhat-release)
  osfamily='Fedora'
elif test -f /usr/bin/yum; then
  operatingsystemmajrelease=$(awk '{print $3}' /etc/redhat-release| cut -c1)
  osfamily='RedHat'
else
  osfamily=$(uname)
fi

case "${osfamily}" in
'Fedora')
  wget "https://yum.puppetlabs.com/puppetlabs-release-pc1-fedora-${operatingsystemmajrelease}.noarch.rpm" -O /tmp/puppetlabs-release-pc1.rpm
  rpm -ivh /tmp/puppetlabs-release-pc1.rpm
  for puppet_agent_version in 1.5.3-1 1.6.0-1 1.6.1-1 1.6.2-1 1.7.0-1; do
    dnf install -y "puppet-agent-${puppet_agent_version}.fedoraf${operatingsystemmajrelease}"
    output_file="/vagrant/$(facter --version | cut -c1-3)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    [ ! -f ${output_file} ] && facter --show-legacy -p -j | tee ${output_file}
  done
  ;;
'RedHat')
  wget "https://yum.puppetlabs.com/puppetlabs-release-pc1-el-${operatingsystemmajrelease}.noarch.rpm" -O /tmp/puppetlabs-release-pc1.rpm
  rpm -ivh /tmp/puppetlabs-release-pc1.rpm
  for puppet_agent_version in 1.2.2 1.4.2 1.5.3 1.10.4; do
    yum install -y puppet-agent-${puppet_agent_version}
    output_file="/vagrant/$(facter --version | cut -c1-3)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    [ ! -f ${output_file} ] && facter --show-legacy -p -j | tee ${output_file}
  done
  ;;

'Debian')
  case "${lsbdistcodename}" in
    *xenial*) lsbdistcodename='wily' ;;
    *serena*) lsbdistcodename='xenial' ;;
  esac
  apt-get install -y wget
  wget "https://apt.puppetlabs.com/puppetlabs-release-pc1-${lsbdistcodename}.deb" -O /tmp/puppetlabs-release-pc1.deb
  dpkg --install /tmp/puppetlabs-release-pc1.deb
  apt-get update
  for puppet_agent_version in 1.10.7 1.2.2 1.4.2 1.5.3 1.10.6;  do
    apt-get -y --force-yes install puppet-agent=${puppet_agent_version}*
    output_file="/vagrant/$(facter --version | cut -c1-3)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    [ ! -f ${output_file} ] && facter --show-legacy -p -j | tee ${output_file}
  done
  apt-get install -y make gcc libgmp-dev
  ;;
'FreeBSD')
  pkg update
  pkg install -y sysutils/puppet5 sysutils/facter
  output_file="/vagrant/$(facter --version | cut -c1-3)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
  mkdir -p $(dirname ${output_file})
  [ ! -f ${output_file} ] && facter --show-legacy -p -j | tee ${output_file}
  ;;
esac

operatingsystem=$(facter operatingsystem | tr '[:upper:]' '[:lower:]')
operatingsystemrelease=$(facter operatingsystemrelease)
operatingsystemmajrelease=$(facter operatingsystemmajrelease)
hardwaremodel=$(facter hardwaremodel)

[ "${hardwaremodel}" = 'amd64' ] && hardwaremodel=x86_64

PATH=/opt/puppetlabs/puppet/bin:$PATH
gem install bundler --no-ri --no-rdoc --no-format-executable
bundle install --path vendor/bundler

for version in 1.6.0 1.7.0 2.0.0 2.1.0 2.2.0 2.3.0 2.4.0 2.5.0; do
  FACTER_GEM_VERSION="~> ${version}" bundle update
  case "${operatingsystem}" in
    openbsd)
      output_file="/vagrant/$(bundle exec facter --version | cut -c1-3)/${operatingsystem}-${operatingsystemrelease}-${hardwaremodel}.facts"
      ;;
    *)
      output_file="/vagrant/$(bundle exec facter --version | cut -c1-3)/${operatingsystem}-${operatingsystemmajrelease}-${hardwaremodel}.facts"
      ;;
  esac
  [ -f ${output_file} ] && continue
  mkdir -p $(dirname $output_file)
  echo $version | grep -q -E '^1\.' &&
    FACTER_GEM_VERSION="~> ${version}" bundle exec facter -j | bundle exec ruby -e 'require "json"; jj JSON.parse gets' | tee $output_file ||
    FACTER_GEM_VERSION="~> ${version}" bundle exec facter -j | tee $output_file
done
