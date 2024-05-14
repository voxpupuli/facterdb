#!/usr/bin/env bash

export PATH=/opt/puppetlabs/bin:$PATH

apt_install() {
    DEBIAN_FRONTEND=noninteractive \
        apt-get --option Dpkg::Options::="--force-confdef" \
                --option Dpkg::Options::="--force-confnew" \
                install --yes --force-yes "$@"
}

if test -f /usr/bin/zypper; then
  zypper --non-interactive --gpg-auto-import-keys refresh
  zypper --non-interactive install ruby-devel
  osfamily='Suse'
  # This is Leap which is based on SLES 12
  if [[ `cat /etc/os-release |grep -e '^VERSION="42' -c` == 1  ]]; then
    operatingsystemmajrelease=12
  elif test -r /etc/os-release; then
    operatingsystemmajrelease=$(. /etc/os-release ; echo ${VERSION} | cut -d. -f1 | cut -d - -f1)
  else
    operatingsystemmajrelease=$(cat /etc/SuSE-release | grep ^VERSION | cut -d' ' -f3)
  fi
elif test -f /usr/bin/apt-get; then
  apt-get update
  apt_install lsb-release
  lsbdistcodename=$(lsb_release -sc)
  operatingsystem=$(lsb_release -si)
  operatingsystemmajrelease=$(lsb_release -sr)
  osfamily='Debian'
elif test -f /etc/redhat-release ; then
  operatingsystemmajrelease=$(rpm -qf /etc/redhat-release --queryformat '%{version}' | cut -f1 -d'.')
  osfamily='RedHat'
elif test -f '/usr/bin/pacman'; then
  operatingsystemmajrelease=3
  osfamily='Archlinux'
elif test -f '/etc/gentoo-release'; then
  osfamily='Gentoo'
elif test -f '/etc/os-release' && grep -q 'Amazon' '/etc/os-release'; then
  osfamily='RedHat'
  operatingsystemmajrelease='7'
else
  osfamily=$(uname)
fi

case "${osfamily}" in
'RedHat')
  . /etc/os-release
  if [[ $ID == fedora ]]; then
    distcode=fedora
  else
    distcode=el
  fi
  yum -y install "https://yum.puppetlabs.com/puppet6-release-${distcode}-${operatingsystemmajrelease}.noarch.rpm"
  if [[ "${?}" == 0 ]]; then
    for puppet_agent_version in 6.25.0 6.27.1; do
      if yum install -y puppet-agent-${puppet_agent_version}; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    yum remove -y puppet6-release
  fi
  wget "http://yum.puppetlabs.com/puppet7-release-el-${operatingsystemmajrelease}.noarch.rpm" -O /tmp/puppet7-release.rpm
  if test -f /tmp/puppet7-release.rpm; then
    rpm -ivh /tmp/puppet7-release.rpm
    for puppet_agent_version in 7.5.0 7.6.1 7.17.0 7.24.0; do
      if yum install -y puppet-agent-${puppet_agent_version}; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    yum remove -y puppet7-release
  fi
  wget "http://yum.puppetlabs.com/puppet8-release-el-${operatingsystemmajrelease}.noarch.rpm" -O /tmp/puppet8-release.rpm
  if test -f /tmp/puppet8-release.rpm; then
    rpm -ivh /tmp/puppet8-release.rpm
    for puppet_agent_version in 8.0.0; do
      if yum install -y puppet-agent-${puppet_agent_version}; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter os.release.major)-$(facter os.hardware).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    yum remove -y puppet8-release
  fi
  ;;
'Debian')
  apt_install curl file
  curl "https://apt.puppetlabs.com/puppet6-release-${lsbdistcodename}.deb" -o /tmp/puppet6-release.deb
  # apt.puppetlabs.com returns an html document if the requested deb doesn't exist and /tmp/puppet6-release.deb will be an html doc
  if test "$?" -eq 0 -a -f /tmp/puppet6-release.deb && [[ "$(file -b /tmp/puppet6-release.deb)" =~ "Debian binary package".* ]] ; then
    dpkg --install /tmp/puppet6-release.deb
    apt-get update
    # as of 2023-04-27 older 6.x series aren't available (i.e. facter 3.12)
    # the trailing dot is so that 6.4.* is the match so we get the last in the 6.4 series and not 6.40
    for puppet_agent_version in 6.4. 6.28.; do
      if apt_install puppet-agent=${puppet_agent_version}*; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    apt-get -y remove --purge puppet6-release
  fi
  # libaugeas-dev is needed when we generate facts via the facter gem. Otherwise augeas.version fact is missing
  apt_install curl file libaugeas-dev
  curl "https://apt.puppetlabs.com/puppet7-release-${lsbdistcodename}.deb" -o /tmp/puppet7-release.deb
  # apt.puppetlabs.com returns an html document if the requested deb doesn't exist and /tmp/puppet6-release.deb will be an html doc
  if test "$?" -eq 0 -a -f /tmp/puppet7-release.deb && [[ "$(file -b /tmp/puppet7-release.deb)" =~ "Debian binary package".* ]] ; then
    dpkg --install /tmp/puppet7-release.deb
    apt-get update
    for puppet_agent_version in 7.5.0 7.6.1 7.12.0 7.24.0; do
      if apt_install puppet-agent=${puppet_agent_version}*; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    apt-get -y remove --purge puppet7-release
  fi
  curl "https://apt.puppetlabs.com/puppet8-release-${lsbdistcodename}.deb" -o /tmp/puppet8-release.deb
  # apt.puppetlabs.com returns an html document if the requested deb doesn't exist and /tmp/puppet6-release.deb will be an html doc
  if test "$?" -eq 0 -a -f /tmp/puppet8-release.deb && [[ "$(file -b /tmp/puppet8-release.deb)" =~ "Debian binary package".* ]] ; then
    dpkg --install /tmp/puppet8-release.deb
    apt-get update
    for puppet_agent_version in 8.0.0; do
      if apt_install puppet-agent=${puppet_agent_version}*; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter os.release.major)-$(facter os.hardware).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    apt-get -y remove --purge puppet8-release
  fi
  # libc6-dev needed to build the ffi gem
  apt_install make gcc libgmp-dev libc6-dev

  # puppetlabs repos/packages not yet available on bookworm https://puppet.atlassian.net/browse/PA-4995
  # simply install puppet-agent that comes with the distro
  if [[ "bookworm" =~ ${lsbdistcodename} ]]; then
    apt_install ruby rubygems ruby-dev
    facter --show-legacy -p -j | tee ${output_file}
  fi

  # There are no puppet-agent packages for $releasename yet, so generate a Facter 3.x
  # fact set from the official Debian package.
  if [[ "hirsute" =~ ${lsbdistcodename} || "impish" =~ ${lsbdistcodename} || "jammy" =~ ${lsbdistcodename} || "kinetic" =~ ${lsbdistcodename} ]]; then
    apt_install ruby rubygems ruby-dev puppet facter
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
    mkdir -p $(dirname ${output_file})
    facter --show-legacy -p -j | tee ${output_file}
  fi
  ;;
'FreeBSD')
  pkg update
  for facter_package in facter rubygem-facter ; do
    pkg install -fy ${facter_package}

    # something about the pkg update process causes the shared folder mount to
    # get into an unusable state, so we remount it here before generating any
    # fact sets.
    umount /vagrant
    mount -t vboxvfs Vagrant /vagrant
    hardwaremodel=$(facter hardwaremodel)
    [ "${hardwaremodel}" = 'amd64' ] && hardwaremodel=x86_64
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-${hardwaremodel}.facts"
    mkdir -p $(dirname ${output_file})
    [ ! -f ${output_file} ] && facter --show-legacy -p -j | tee ${output_file}
  done
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
  # install deps that we need later for gem based setup
  zypper --gpg-auto-import-keys --non-interactive install make gcc
  if [[ ${operatingsystemmajrelease} -lt 12 ]]; then
    # SLES 11 can no longer wget the release file with HTTPS due to mis-matched SSL support:
    http_method='http'
  else
    http_method='https'
  fi
  if rpm -Uvh ${http_method}://yum.puppet.com/puppet6-release-sles-${operatingsystemmajrelease}.noarch.rpm; then
    for puppet_agent_version in 6.25.0 6.27.1; do
      if zypper --gpg-auto-import-keys --non-interactive install puppet-agent-${puppet_agent_version}; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    zypper --non-interactive remove puppet6-release
  fi
  if rpm -Uvh ${http_method}://yum.puppet.com/puppet7-release-sles-${operatingsystemmajrelease}.noarch.rpm; then
    for puppet_agent_version in 7.5.0 7.6.1 7.12.0 7.24.0; do
      if zypper --gpg-auto-import-keys --non-interactive install puppet-agent-${puppet_agent_version}; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    zypper --non-interactive remove puppet7-release
  fi
  if rpm -Uvh ${http_method}://yum.puppet.com/puppet8-release-sles-${operatingsystemmajrelease}.noarch.rpm; then
    for puppet_agent_version in 8.0.0; do
      if zypper --gpg-auto-import-keys --non-interactive install puppet-agent-${puppet_agent_version}; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemmajrelease)-$(facter hardwaremodel).facts"
        mkdir -p $(dirname ${output_file})
        facter --show-legacy -p -j | tee ${output_file}
      fi
    done
    zypper --non-interactive remove puppet8-release
  fi
  ;;
'Archlinux')
  pacman -Syu --noconfirm ruby puppet ruby-bundler base-devel dnsutils facter
  output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter hardwaremodel).facts"
  mkdir -p $(dirname ${output_file})
  facter --show-legacy -p -j | tee ${output_file}
  ;;
'Gentoo')
  emerge -vq1 dev-lang/ruby dev-ruby/bundler app-admin/puppet
  output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter operatingsystem | tr '[:upper:]' '[:lower:]')-$(facter hardwaremodel).facts"
  mkdir -p $(dirname ${output_file})
  facter --show-legacy -p -j | tee ${output_file}
esac

# this lower section relies on the ruby version and facter version that came
# with the last installed puppet_agent per above
# puppet-agent 8.0.0 has ruby 3.2.2 and it cant install 4.0.0, 4.1.0 facter gem
operatingsystem=$(facter operatingsystem | tr '[:upper:]' '[:lower:]')
operatingsystemrelease=$(facter operatingsystemrelease)
operatingsystemmajrelease=$(facter operatingsystemmajrelease)
hardwaremodel=$(facter hardwaremodel)

[ "${hardwaremodel}" = 'amd64' ] && hardwaremodel=x86_64

PATH=/opt/puppetlabs/puppet/bin:$PATH

gem install bundler --no-document --no-format-executable
bundle config set path 'vendor/bundler'
bundle install

for version in 4.0.0 4.1.0 4.2.0 4.3.0 4.4.0 4.5.0; do
  FACTER_GEM_VERSION="~> ${version}" bundle update
  # sometimes all versions of facter are not possible, if the bundle update fails, skip the rest of the loop
  if [ $? -ne 0 ]; then
    echo "bundle update failed for facter version: $version"
    continue
  fi

  # This is another workaround for shared folder on FreeBSD.  "Accessing"
  # /vagrant helps to not encounter a bug where we try to access files in
  # /vagrant/subdir/file
  ls -d /vagrant > /dev/null
  ls -l /vagrant > /dev/null

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
  if [ -f $output_file ]; then
    continue
  fi
  mkdir -p $(dirname $output_file)
  echo $version | grep -q -E '^1\.' &&
    FACTER_GEM_VERSION="~> ${version}" bundle exec facter --show-legacy --json | bundle exec ruby -e 'require "json"; jj JSON.parse gets' | tee $output_file ||
    FACTER_GEM_VERSION="~> ${version}" bundle exec facter --show-legacy --json | tee $output_file
done
