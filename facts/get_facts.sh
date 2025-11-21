#!/usr/bin/env bash

export PATH=/opt/puppetlabs/bin:$PATH

# does not exist on BSD
if [ -d "/proc/sys" ]; then
  # ensure IPv6 is always enabled, some boxes disable it by default, e.g. Fedora and RedHat
  sysctl -w net.ipv6.conf.all.disable_ipv6=0
  puppetAgentVersionList='/vagrant/versions.txt'
  if test ! -f $puppetAgentVersionList; then
    echo 'Missing version list'
    exit 1
  fi
  puppet8_agent_versions=$(grep --only-matching --perl-regexp '^\d+\.\d+\.\d+' $puppetAgentVersionList)
  if test -z "$puppet8_agent_versions"; then
    echo 'Version list is empty'
    exit 1
  fi
else
  echo 'ipv6_activate_all_interfaces="YES"' >> /etc/rc.conf
  /etc/rc.d/netif restart
  sleep 15 # sleep a bit until dhcp got a new ip
  ifconfig
fi

apt_install() {
    DEBIAN_FRONTEND=noninteractive \
        apt-get --option Dpkg::Options::="--force-confdef" \
                --option Dpkg::Options::="--force-confnew" \
                install --yes --force-yes "$@"
}

if test -f /usr/bin/zypper; then
  zypper --non-interactive --gpg-auto-import-keys refresh
  zypper --non-interactive install ruby-devel augeas
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
  operatingsystem_lowercase=$(echo $operatingsystem | tr '[:upper:]' '[:lower:]')
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
  if grep -q 'VERSION="2023"' '/etc/os-release'; then
    operatingsystemmajrelease='9'
  else
    operatingsystemmajrelease='7'
  fi
else
  osfamily=$(uname)
fi

. /etc/os-release

case "${osfamily}" in
'RedHat')
  if [[ $ID == fedora ]]; then
    distcode=fedora
    dnf -y install facter ruby ruby-devel wget make gcc net-tools augeas
  elif [[ $ID == ol ]]; then
    distcode=el
    dnf -y groupinstall 'Development Tools'
  elif [[ $ID == amzn ]]; then
    distcode=el
    dnf -y install ruby ruby-devel wget make gcc net-tools augeas
  else
    distcode=el
  fi
  wget "https://yum.overlookinfratech.com/openvox8-release-${distcode}-${operatingsystemmajrelease}.noarch.rpm" -O /tmp/openvox8-release.rpm
  if test -f /tmp/openvox8-release.rpm; then
    rpm -ivh /tmp/openvox8-release.rpm
    for puppet_agent_version in $puppet8_agent_versions; do
      if yum install -y openvox-agent-${puppet_agent_version}; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter os.release.major)-$(facter os.hardware).facts"
        mkdir -p $(dirname ${output_file})
        facter --puppet --json | tee ${output_file}
      fi
    done
    yum remove -y openvox8-release
  fi
  ;;
'Debian')
  # libaugeas-dev is needed when we generate facts via the facter gem. Otherwise augeas.version fact is missing
  apt_install curl file libaugeas-dev
  # VERSION_ID comes from /etc/os-release
  curl "https://apt.overlookinfratech.com/openvox8-release-${operatingsystem_lowercase}${VERSION_ID}.deb" -o /tmp/openvox8-release.deb
  # apt.overlookinfratech.com returns an html document if the requested deb doesn't exist and /tmp/openvox8-release.deb will be an ASCII file
  if test "$?" -eq 0 -a -f /tmp/openvox8-release.deb && [[ "$(file -b /tmp/openvox8-release.deb)" =~ "Debian binary package".* ]] ; then
    dpkg --install /tmp/openvox8-release.deb
    apt-get update
    for puppet_agent_version in $puppet8_agent_versions; do
      if apt_install openvox-agent=${puppet_agent_version}*; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter os.release.major)-$(facter os.hardware).facts"
        mkdir -p $(dirname ${output_file})
        facter --puppet --json | tee ${output_file}
      fi
    done
    apt-get -y remove --purge openvox8-release
  fi
  # libc6-dev needed to build the ffi gem
  apt_install make gcc libgmp-dev libc6-dev ruby ruby-dev

  # There are no puppet-agent packages for $releasename yet, so generate a Facter 3.x
  # fact set from the official Debian package.
  if [[ "hirsute" =~ ${lsbdistcodename} || "impish" =~ ${lsbdistcodename} || "jammy" =~ ${lsbdistcodename} || "kinetic" =~ ${lsbdistcodename} ]]; then
    apt_install ruby rubygems ruby-dev puppet facter
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter os.release.major)-$(facter os.hardware).facts"
    mkdir -p $(dirname ${output_file})
    facter --puppet --json | tee ${output_file}
  fi
  ;;
'FreeBSD')
  pkg update
  for facter_package in rubygem-openfact ; do
    pkg install -fy ${facter_package}

    # something about the pkg update process causes the shared folder mount to
    # get into an unusable state, so we remount it here before generating any
    # fact sets.
    umount /vagrant
    mount -t vboxvfs Vagrant /vagrant
    hardwaremodel=$(facter os.hardware)
    [ "${hardwaremodel}" = 'amd64' ] && hardwaremodel=x86_64
    output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter os.release.major)-${hardwaremodel}.facts"
    mkdir -p $(dirname ${output_file})
    [ ! -f ${output_file} ] && facter --puppet --json | tee ${output_file}
  done
  ;;
'OpenBSD')
  hardwaremodel=$(facter os.hardware)
  [ "${hardwaremodel}" = 'amd64' ] && hardwaremodel=x86_64
  # Vagrant box should already have puppet & facter installed
  output_file="/vagrant/$(facter --version | cut -d. -f1-2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter operatingsystemrelease)-${hardwaremodel}.facts"
  mkdir -p $(dirname ${output_file})
  [ ! -f ${output_file} ] && facter --puppet --json | tee ${output_file}
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
  if rpm -Uvh ${http_method}://yum.puppet.com/puppet8-release-sles-${operatingsystemmajrelease}.noarch.rpm; then
    for puppet_agent_version in $puppet8_agent_versions; do
      if zypper --gpg-auto-import-keys --non-interactive install puppet-agent-${puppet_agent_version}; then
        output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter os.release.major)-$(facter os.hardware).facts"
        mkdir -p $(dirname ${output_file})
        facter --puppet --json | tee ${output_file}
      fi
    done
    zypper --non-interactive remove puppet8-release
  fi
  ;;
'Archlinux')
  pacman --sync --refresh --sysupgrade --noconfirm ruby ruby-bundler base-devel dnsutils facter augeas
  output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter os.hardware).facts"
  mkdir -p $(dirname ${output_file})
  facter --puppet --json | tee ${output_file}
  ;;
'Gentoo')
  emerge -vq1 dev-lang/ruby dev-ruby/bundler app-admin/puppet dev-ruby/facter sys-apps/dmidecode app-admin/augeas
  output_file="/vagrant/$(facter --version | cut -d. -f1,2)/$(facter os.name | tr '[:upper:]' '[:lower:]')-$(facter os.hardware).facts"
  mkdir -p $(dirname ${output_file})
  facter --puppet --json | tee ${output_file}
esac

# this lower section relies on the ruby version and facter version that came
# with the last installed puppet_agent per above
# puppet-agent 8.0.0 has ruby 3.2.2 and it cant install 4.0.0, 4.1.0 facter gem
operatingsystem=$(facter os.name | tr '[:upper:]' '[:lower:]')
operatingsystemrelease=$(facter os.release.full)
operatingsystemmajrelease=$(facter os.release.major)
hardwaremodel=$(facter os.hardware)

[ "${hardwaremodel}" = 'amd64' ] && hardwaremodel=x86_64

PATH=/opt/puppetlabs/puppet/bin:$PATH
gem install bundler --no-document --no-format-executable
bundle config set path 'vendor/bundler'
bundle install

declare -a versions=(
  '4.2.14'
  '4.3.0'
  '4.4.3'
  '4.5.2'
  '4.6.0'
  '4.7.0'
  '4.8.0'
  '4.9.0'
  '4.10.0'
)

for version in "${versions[@]}"; do
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
    FACTER_GEM_VERSION="~> ${version}" bundle exec facter --json | bundle exec ruby -e 'require "json"; jj JSON.parse gets' | tee $output_file ||
    FACTER_GEM_VERSION="~> ${version}" bundle exec facter --json | tee $output_file
done
