#!/bin/sh

export PATH=/opt/puppetlabs/bin:$PATH

if test -f /usr/bin/zypper; then
  zypper --non-interactive --gpg-auto-import-keys refresh
  zypper --non-interactive install ruby-devel
  osfamily='Suse'
elif test -f /usr/bin/apt-get; then
  apt-get update
  apt-get install -y lsb-release
  lsbdistcodename=$(lsb_release -sc)
  operatingsystem=$(lsb_release -si)
  operatingsystemmajrelease=$(lsb_release -sr)
  osfamily='Debian'
elif test -f /usr/bin/dnf; then
  operatingsystemmajrelease=$(cat /etc/redhat-release | cut -d' ' -f3 )
  osfamily='Fedora'
elif test -f /usr/bin/yum; then
  operatingsystemmajrelease=$(cat /etc/redhat-release | cut -d' ' -f4 | cut -c1)
  osfamily='RedHat'
elif test -f '/usr/bin/pacman'; then
  operatingsystemmajrelease=3
  osfamily='Archlinux'
else
  osfamily=$(uname)
fi

case "${osfamily}" in
'Fedora')
  wget "https://yum.puppetlabs.com/puppetlabs-release-pc1-fedora-${operatingsystemmajrelease}.noarch.rpm" -O /tmp/puppetlabs-release-pc1.rpm
  rpm -ivh /tmp/puppetlabs-release-pc1.rpm
  for puppet_agent_version in 1.5.3-1 1.6.0-1 1.6.1-1 1.6.2-1 1.7.0-1; do
    dnf install -y "puppet-agent-${puppet_agent_version}.fedoraf${operatingsystemmajrelease}"
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    facter --show-legacy -p -j | tee ${output_file}
  done
  ;;
'RedHat')
  wget "https://yum.puppetlabs.com/puppetlabs-release-pc1-el-${operatingsystemmajrelease}.noarch.rpm" -O /tmp/puppetlabs-release-pc1.rpm
  rpm -ivh /tmp/puppetlabs-release-pc1.rpm
  for puppet_agent_version in 1.2.2 1.4.2 1.5.3 1.10.4; do
    yum install -y puppet-agent-${puppet_agent_version}
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    facter --show-legacy -p -j | tee ${output_file}
  done
  ;;

'Debian')
  if [[ "xenial" =~ ${lsbdistcodename} ]]; then
    lsbdistcodename='wily'
  fi
  if [[ "serena" =~ ${lsbdistcodename} ]]; then
    lsbdistcodename='xenial'
  fi
  apt-get install -y wget
  wget "https://apt.puppetlabs.com/puppetlabs-release-pc1-${lsbdistcodename}.deb" -O /tmp/puppetlabs-release-pc1.deb
  dpkg --install /tmp/puppetlabs-release-pc1.deb
  apt-get update
  for puppet_agent_version in 1.2.2 1.4.2 1.5.3; do
    apt-get -y --force-yes install puppet-agent=${puppet_agent_version}*
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    facter --show-legacy -p -j | tee ${output_file}
  done
  apt-get install -y make gcc libgmp-dev
  ;;
'FreeBSD')
  pkg update
  pkg install -y sysutils/puppet5 sysutils/facter
  output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
  mkdir -p $(dirname ${output_file})
  [ ! -f ${output_file} ] && facter --show-legacy -p -j | tee ${output_file}
  ;;
'Suse')
  if [[ `cat /etc/os-release |grep -e '^VERSION="42' -c` == 1  ]]; then
    # This is Leap which is based on SLES 12
    rpm -Uvh https://yum.puppet.com/puppetlabs-release-pc1-sles-12.noarch.rpm
    zypper --gpg-auto-import-keys --non-interactive refresh
    for puppet_agent_version in 1.6.2 1.7.2 1.8.3 1.9.3 1.10.8; do
      zypper --non-interactive install puppet-agent-${puppet_agent_version}
      output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
      mkdir -p $(dirname ${output_file})
      facter --show-legacy -p -j | tee ${output_file}
    done
    zypper --non-interactive remove puppetlabs-release-pc1
    rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-sles-12.noarch.rpm
    for puppet_agent_version in 5.0.1 5.1.0 5.2.0 5.3.2; do
      zypper --non-interactive install puppet-agent-${puppet_agent_version}
      output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
      mkdir -p $(dirname ${output_file})
      facter --show-legacy -p -j | tee ${output_file}
    done
  fi
  ;;
'Archlinux')
  pacman -Syu --noconfirm ruby puppet ruby-bundler
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
      output_file="/vagrant/$(bundle exec facter --version | cut -d. -f1,2)/${operatingsystem}-${operatingsystemrelease}-${hardwaremodel}.facts"
      ;;
    *)
      output_file="/vagrant/$(bundle exec facter --version | cut -d. -f1,2)/${operatingsystem}-${operatingsystemmajrelease}-${hardwaremodel}.facts"
      ;;
  esac
  mkdir -p $(dirname $output_file)
  echo $version | grep -q -E '^1\.' &&
    FACTER_GEM_VERSION="~> ${version}" bundle exec facter -j | bundle exec ruby -e 'require "json"; jj JSON.parse gets' | tee $output_file ||
    FACTER_GEM_VERSION="~> ${version}" bundle exec facter -j | tee $output_file
done
