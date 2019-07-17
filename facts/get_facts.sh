#!/bin/bash

export PATH=/opt/puppetlabs/bin:$PATH

if test -f /usr/bin/zypper; then
  zypper --non-interactive --gpg-auto-import-keys refresh
  zypper --non-interactive install ruby-devel
  osfamily='Suse'
  # This is Leap which is based on SLES 12
  if [[ `cat /etc/os-release |grep -e '^VERSION="42' -c` == 1  ]]; then
    operatingsystemmajrelease=12
  elif test -r /etc/os-release; then
    operatingsystemmajrelease=$(. /etc/os-release ; echo ${VERSION} | cut -d. -f1)
  else
    operatingsystemmajrelease=$(cat /etc/SuSE-release | grep ^VERSION | cut -d' ' -f3)
  fi
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
  operatingsystemmajrelease=$(cat /etc/redhat-release | sed 's/[^0-9.]//g' | cut -d'.' -f1)
  osfamily='RedHat'
elif test -f '/usr/bin/pacman'; then
  operatingsystemmajrelease=3
  osfamily='Archlinux'
elif test -f '/etc/gentoo-release'; then
  osfamily='Gentoo'
else
  osfamily=$(uname)
fi

case "${osfamily}" in
'Fedora')

  yum install -y "https://yum.puppetlabs.com/puppetlabs-release-pc1-fedora-${operatingsystemmajrelease}.noarch.rpm"
  # Puppet 4 doesn't support Fedora 28 anymore
  if [[ "${?}" == 0 ]]; then
    for puppet_agent_version in 1.5.3-1 1.6.0-1 1.6.1-1 1.6.2-1 1.7.0-1 1.10.12-1; do
      dnf install -y "puppet-agent-${puppet_agent_version}.fedoraf${operatingsystemmajrelease}"
      output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
      mkdir -p $(dirname ${output_file})
      facter --show-legacy -p -j | tee ${output_file}
    done
    yum remove -y puppetlabs-release-pc1
  fi
  # Puppet 5
  yum install -y "https://yum.puppetlabs.com/puppet5/puppet5-release-fedora-${operatingsystemmajrelease}.noarch.rpm"
  for puppet_agent_version in 5.3.1-1 5.3.2-1 5.3.3-1 5.3.4-1 5.3.5-1 5.4.0-1 5.5.6-1; do
    # Package naming changed with Fedora 28
    [[ ${operatingsystemmajrelease} -ge 28 ]] && osprefix='fc' || osprefix='fedoraf'
    echo  dnf install -y "puppet-agent-${puppet_agent_version}.${osprefix}${operatingsystemmajrelease}"
    dnf install -y "puppet-agent-${puppet_agent_version}.${osprefix}${operatingsystemmajrelease}"
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    echo "Outputfile: $output_file"
    mkdir -p $(dirname ${output_file})
    facter --show-legacy -p -j | tee ${output_file}
  done

  ;;
'RedHat')
  if [[ ${operatingsystemmajrelease} -eq 5 ]]; then
    # CentOS 5 can no longer wget the release file with HTTPS due to mis-matched SSL support:
    http_method='http'
    # The default CentOS repositories no longer work and prevent yum from working:
    rm -f /etc/yum.repos.d/CentOS*
  else
    http_method='https'
  fi
  wget "${http_method}://yum.puppetlabs.com/puppetlabs-release-pc1-el-${operatingsystemmajrelease}.noarch.rpm" -O /tmp/puppetlabs-release-pc1.rpm
  rpm -ivh /tmp/puppetlabs-release-pc1.rpm
  for puppet_agent_version in 1.2.2 1.4.2 1.5.3 1.10.4; do
    yum install -y puppet-agent-${puppet_agent_version}
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    facter --show-legacy -p -j | tee ${output_file}
  done
  wget "http://yum.puppetlabs.com/puppet5/puppet5-release-el-${operatingsystemmajrelease}.noarch.rpm" -O /tmp/puppet5-release.rpm
  rpm -ivh /tmp/puppet5-release.rpm
  for puppet_agent_version in 5.0.1 5.1.0 5.3.7 5.4.0 5.5.3; do
    yum install -y puppet-agent-${puppet_agent_version}
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    facter --show-legacy -p -j | tee ${output_file}
  done
  ;;

'Debian')
  if [[ "serena" =~ ${lsbdistcodename} ]]; then
    lsbdistcodename='xenial'
  fi
  if [[ "tessa" =~ ${lsbdistcodename} ]]; then
    lsbdistcodename='bionic'
  fi
  apt-get install -y wget
  wget "https://apt.puppetlabs.com/puppetlabs-release-pc1-${lsbdistcodename}.deb" -O /tmp/puppetlabs-release-pc1.deb
  if test -f /tmp/puppetlabs-release.deb; then
    dpkg --install /tmp/puppetlabs-release-pc1.deb
    apt-get update
    for puppet_agent_version in 1.2.2 1.4.2 1.5.3; do
      if apt-get -y --force-yes install puppet-agent=${puppet_agent_version}*; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    apt-get -y remove --purge puppetlabs-release-pc1
  fi
  wget "https://apt.puppetlabs.com/puppet5-release-${lsbdistcodename}.deb" -O /tmp/puppet5-release.deb
  if test -f /tmp/puppet5-release.deb; then
    dpkg --install /tmp/puppet5-release.deb
    apt-get update
    for puppet_agent_version in 5.0.1 5.1.0 5.3.7 5.4.0 5.5.3; do
      if apt-get -y --force-yes install puppet-agent=${puppet_agent_version}*; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    apt-get -y remove --purge puppet5-release
  fi
  wget "https://apt.puppetlabs.com/puppet6-release-${lsbdistcodename}.deb" -O /tmp/puppet6-release.deb
  if test -f /tmp/puppet6-release.deb; then
    dpkg --install /tmp/puppet6-release.deb
    apt-get update
    for puppet_agent_version in 6.2.0 6.4.2 6.6.0; do
      if apt-get -y --force-yes install puppet-agent=${puppet_agent_version}*; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    apt-get -y remove --purge puppet6-release
  fi
  apt-get install -y make gcc libgmp-dev
  ;;
'FreeBSD')
  pkg update
  pkg install -y sysutils/puppet5 sysutils/facter sysutils/rubygem-bundler
  # something about the pkg update process causes the shared folder mount to
  # get into an unusable state, so we remount it here before generating any
  # fact sets.
  umount /vagrant
  mount -t vboxvfs Vagrant /vagrant
  output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
  mkdir -p $(dirname ${output_file})
  [ ! -f ${output_file} ] && facter --show-legacy -p -j | tee ${output_file}
  ;;
'OpenBSD')
  hardwaremodel=$(facter hardwaremodel)
  [ "${hardwaremodel}" = 'amd64' ] && hardwaremodel=x86_64
  # Vagrant box should already have puppet & facter installed
  output_file="/vagrant/$(facter --version | cut -d. -f1-2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemrelease)-${hardwaremodel}.facts"
  mkdir -p $(dirname ${output_file})
  [ ! -f ${output_file} ] && facter --show-legacy -p -j | tee ${output_file}
  ;;
'Suse')
  if [[ ${operatingsystemmajrelease} -lt 12 ]]; then
    # SLES 11 can no longer wget the release file with HTTPS due to mis-matched SSL support:
    http_method='http'
  else
    http_method='https'
  fi
  if [[ ${operatingsystemmajrelease} -le 12 ]]; then
    rpm -Uvh ${http_method}://yum.puppet.com/puppetlabs-release-pc1-sles-${operatingsystemmajrelease}.noarch.rpm
    zypper --gpg-auto-import-keys --non-interactive refresh
    for puppet_agent_version in 1.6.2 1.7.2 1.8.3 1.9.3 1.10.8; do
      zypper --non-interactive install puppet-agent-${puppet_agent_version}
      output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
      mkdir -p $(dirname ${output_file})
      facter --show-legacy -p -j | tee ${output_file}
    done
    zypper --non-interactive remove puppetlabs-release-pc1
  fi
  if [[ ${operatingsystemmajrelease} -le 12 ]]; then
    pup5vers="5.0.1 5.1.0 5.2.0 5.3.2 5.4.0 5.5.8"
  else
    pup5vers="5.5.8 5.5.10"
  fi
  rpm -Uvh ${http_method}://yum.puppet.com/puppet5/puppet5-release-sles-${operatingsystemmajrelease}.noarch.rpm
  for puppet_agent_version in ${pup5vers}; do
    zypper --gpg-auto-import-keys --non-interactive install puppet-agent-${puppet_agent_version}
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    facter --show-legacy -p -j | tee ${output_file}
  done
  ;;
'Archlinux')
  pacman -Syu --noconfirm ruby puppet ruby-bundler base-devel dnsutils facter
  output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter hardwaremodel).facts"
  mkdir -p $(dirname ${output_file})
  facter --show-legacy -p -j | tee ${output_file}
  ;;
'Gentoo')
  emerge -vq1 dev-lang/ruby dev-ruby/bundler app-admin/puppet
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
    archlinux)
      output_file="/vagrant/$(bundle exec facter --version | cut -d. -f1,2)/${operatingsystem}-${hardwaremodel}.facts"
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

