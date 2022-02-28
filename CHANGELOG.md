# Changelog

## [1.14.0](https://rubygems.org/gems/facterdb/versions/1.14.0) (2022-02-28)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.13.0...1.14.0)

**Implemented enhancements:**

- Ubuntu 16: Update facter 3/4 factsets [\#238](https://github.com/voxpupuli/facterdb/pull/238) ([bastelfreak](https://github.com/bastelfreak))
- Add popos 21.10 x86\_64 facts [\#236](https://github.com/voxpupuli/facterdb/pull/236) ([logicminds](https://github.com/logicminds))

## [1.13.0](https://rubygems.org/gems/facterdb/versions/1.13.0) (2022-02-11)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.12.2...1.13.0)

**Implemented enhancements:**

- Add CentOS 9 facter 3.14 facts [\#231](https://github.com/voxpupuli/facterdb/pull/231) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- document minimal Ruby 2.5 version in gemspec [\#233](https://github.com/voxpupuli/facterdb/pull/233) ([bastelfreak](https://github.com/bastelfreak))
- Add Ruby 3.1 to CI matrix [\#232](https://github.com/voxpupuli/facterdb/pull/232) ([bastelfreak](https://github.com/bastelfreak))
- Ensure all facts have osfamily/operatingsystem facts [\#230](https://github.com/voxpupuli/facterdb/pull/230) ([bastelfreak](https://github.com/bastelfreak))
- add spec tests for legacy osfamily and operatingsystem facts [\#228](https://github.com/voxpupuli/facterdb/pull/228) ([jhoblitt](https://github.com/jhoblitt))
- add a default rake target [\#227](https://github.com/voxpupuli/facterdb/pull/227) ([jhoblitt](https://github.com/jhoblitt))
- Remove EOL things from fact collection and align Red Hat OSes [\#187](https://github.com/voxpupuli/facterdb/pull/187) ([ekohl](https://github.com/ekohl))

## [1.12.2](https://rubygems.org/gems/facterdb/versions/1.12.2) (2021-12-15)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.12.1...1.12.2)

**Implemented enhancements:**

- Adding facts for Fedora 35 [\#218](https://github.com/voxpupuli/facterdb/pull/218) ([hbrown-uiowa](https://github.com/hbrown-uiowa))

**Fixed bugs:**

- validate all factsets to legacy facts & fix renaming network related facts [\#225](https://github.com/voxpupuli/facterdb/pull/225) ([bastelfreak](https://github.com/bastelfreak))
- Validate legacy domain/fqdn/hostname fact on all factsets & Add missing fqdn/domain/hostname fact to all factsets [\#224](https://github.com/voxpupuli/facterdb/pull/224) ([bastelfreak](https://github.com/bastelfreak))
- Add test for legacy domain fact & Add/correct legacy domain fact [\#223](https://github.com/voxpupuli/facterdb/pull/223) ([bastelfreak](https://github.com/bastelfreak))
- Add test for legacy FQDN/hostname & correct FQDN/hostname facts [\#222](https://github.com/voxpupuli/facterdb/pull/222) ([bastelfreak](https://github.com/bastelfreak))
- Oraclelinux/RHEL 9: Add legacy facts [\#220](https://github.com/voxpupuli/facterdb/pull/220) ([bastelfreak](https://github.com/bastelfreak))
- Add some CentOS 9 legacy facts [\#219](https://github.com/voxpupuli/facterdb/pull/219) ([traylenator](https://github.com/traylenator))

## [1.12.1](https://rubygems.org/gems/facterdb/versions/1.12.1) (2021-11-25)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.12.0...1.12.1)

**Fixed bugs:**

- Fix hostname facts for freebsd13 and add spec test [\#216](https://github.com/voxpupuli/facterdb/pull/216) ([msalway](https://github.com/msalway))

## [1.12.0](https://rubygems.org/gems/facterdb/versions/1.12.0) (2021-11-10)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.11.0...1.12.0)

**Implemented enhancements:**

- Add support for ubuntu 21.10 and 21.04  [\#209](https://github.com/voxpupuli/facterdb/pull/209) ([hbrown-uiowa](https://github.com/hbrown-uiowa))

**Fixed bugs:**

- Cleanup stdlib/systemd facts and add tests to ensure that they are absent [\#213](https://github.com/voxpupuli/facterdb/pull/213) ([bastelfreak](https://github.com/bastelfreak))
- Re-generating fact sets which were missing the mountpoints fact [\#210](https://github.com/voxpupuli/facterdb/pull/210) ([hbrown-uiowa](https://github.com/hbrown-uiowa))

**Merged pull requests:**

- Gemfile: mention why we include sys-filesystem [\#212](https://github.com/voxpupuli/facterdb/pull/212) ([bastelfreak](https://github.com/bastelfreak))

## [1.11.0](https://rubygems.org/gems/facterdb/versions/1.11.0) (2021-11-05)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.10.1...1.11.0)

**Implemented enhancements:**

- Add Almalinux facts [\#207](https://github.com/voxpupuli/facterdb/pull/207) ([hbrown-uiowa](https://github.com/hbrown-uiowa))
- Add facter 4.x facts for RockyLinux 8 [\#205](https://github.com/voxpupuli/facterdb/pull/205) ([hbrown-uiowa](https://github.com/hbrown-uiowa))
- Generate OL/RHEL/SL facts [\#203](https://github.com/voxpupuli/facterdb/pull/203) ([bastelfreak](https://github.com/bastelfreak))
- Add Facts for Ubuntu 21.04 x86-64, facter 3.14 [\#201](https://github.com/voxpupuli/facterdb/pull/201) ([towo](https://github.com/towo))
- Add Fedora 33 and 34 factsets [\#199](https://github.com/voxpupuli/facterdb/pull/199) ([hbrown-uiowa](https://github.com/hbrown-uiowa))
- Add Fedora 32 facts [\#198](https://github.com/voxpupuli/facterdb/pull/198) ([hbrown-uiowa](https://github.com/hbrown-uiowa))

**Fixed bugs:**

- Add sys-filesystem so that mountpoints fact resolves [\#206](https://github.com/voxpupuli/facterdb/pull/206) ([hbrown-uiowa](https://github.com/hbrown-uiowa))
- \(\#200\) Updated get\_facts.sh and several os facts missing mountpoints [\#202](https://github.com/voxpupuli/facterdb/pull/202) ([michael-riddle](https://github.com/michael-riddle))

## [1.10.1](https://rubygems.org/gems/facterdb/versions/1.10.1) (2021-10-09)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.10.0...1.10.1)

**Fixed bugs:**

- facter 4.0: Regenerate factsets with legacy facts [\#195](https://github.com/voxpupuli/facterdb/pull/195) ([bastelfreak](https://github.com/bastelfreak))
- facter 4.1: Regenerate factsets with legacy facts [\#194](https://github.com/voxpupuli/facterdb/pull/194) ([bastelfreak](https://github.com/bastelfreak))
- facter 4.2: Regenerate factsets with legacy facts [\#193](https://github.com/voxpupuli/facterdb/pull/193) ([bastelfreak](https://github.com/bastelfreak))
- get\_facts.sh: Collect legacy facts as well [\#191](https://github.com/voxpupuli/facterdb/pull/191) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- CI: Test if the gem builds [\#196](https://github.com/voxpupuli/facterdb/pull/196) ([bastelfreak](https://github.com/bastelfreak))
- Remove EoL OSes from Vagrantfile [\#192](https://github.com/voxpupuli/facterdb/pull/192) ([bastelfreak](https://github.com/bastelfreak))
- get\_facts.sh: Ignore facter 1.X/2.x [\#190](https://github.com/voxpupuli/facterdb/pull/190) ([bastelfreak](https://github.com/bastelfreak))

## [1.10.0](https://rubygems.org/gems/facterdb/versions/1.10.0) (2021-09-23)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.9.0...1.10.0)

**Implemented enhancements:**

- Ubuntu 18.04/20.04, RedHat 8: Update factsets [\#188](https://github.com/voxpupuli/facterdb/pull/188) ([bastelfreak](https://github.com/bastelfreak))

## [1.9.0](https://rubygems.org/gems/facterdb/versions/1.9.0) (2021-08-25)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.8.0...1.9.0)

**Implemented enhancements:**

- Add Debian 11 facts [\#185](https://github.com/voxpupuli/facterdb/pull/185) ([smortex](https://github.com/smortex))
- Add more FreeBSD facts [\#184](https://github.com/voxpupuli/facterdb/pull/184) ([smortex](https://github.com/smortex))
- Add Oracle Linux 8 facts [\#183](https://github.com/voxpupuli/facterdb/pull/183) ([as0bu](https://github.com/as0bu))
- Adding puppet7 facter4.2 facts for centos7/8 and debian9/10 [\#181](https://github.com/voxpupuli/facterdb/pull/181) ([jacobmw](https://github.com/jacobmw))
- Adds Rocky Linux vagrant image, facts and get\_facts.sh support [\#176](https://github.com/voxpupuli/facterdb/pull/176) ([fuero](https://github.com/fuero))

## [1.8.0](https://rubygems.org/gems/facterdb/versions/1.8.0) (2021-08-06)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.7.0...1.8.0)

**Implemented enhancements:**

- Add facts for for Darwin 20 \(macOS 11\) x86\_64 [\#179](https://github.com/voxpupuli/facterdb/pull/179) ([yachub](https://github.com/yachub))
- Add CentOS Stream 9 facts [\#177](https://github.com/voxpupuli/facterdb/pull/177) ([mwhahaha](https://github.com/mwhahaha))

**Fixed bugs:**

- Fix broken GHA release job [\#178](https://github.com/voxpupuli/facterdb/pull/178) ([bastelfreak](https://github.com/bastelfreak))

## [1.7.0](https://rubygems.org/gems/facterdb/versions/1.7.0) (2021-07-19)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.6.0...1.7.0)

**Implemented enhancements:**

- Fixes \#173 - Add AlmaLinux [\#174](https://github.com/voxpupuli/facterdb/pull/174) ([maccelf](https://github.com/maccelf))
- Introduce cache to speed things up and cleanup method [\#171](https://github.com/voxpupuli/facterdb/pull/171) ([lzap](https://github.com/lzap))
- Add Facter 4 facts for Debian 10/CentOS 7 [\#170](https://github.com/voxpupuli/facterdb/pull/170) ([genebean](https://github.com/genebean))
- Add Sparc Solaris 11 Facter 4 facts [\#169](https://github.com/voxpupuli/facterdb/pull/169) ([genebean](https://github.com/genebean))

**Merged pull requests:**

- cleanup documentation + migrate CI+release process from travis to github actions [\#172](https://github.com/voxpupuli/facterdb/pull/172) ([bastelfreak](https://github.com/bastelfreak))
- Add Darwin 19 \(macOS 10.15\) x86\_64 Support [\#168](https://github.com/voxpupuli/facterdb/pull/168) ([yachub](https://github.com/yachub))
- Remove `clientX` facts from solaris factsets [\#167](https://github.com/voxpupuli/facterdb/pull/167) ([alexjfisher](https://github.com/alexjfisher))
- Drop EOL Ruby version from CI matrix [\#166](https://github.com/voxpupuli/facterdb/pull/166) ([bastelfreak](https://github.com/bastelfreak))
- facts\_spec: Pathname class is missing [\#165](https://github.com/voxpupuli/facterdb/pull/165) ([lelutin](https://github.com/lelutin))

## [1.6.0](https://rubygems.org/gems/facterdb/versions/1.6.0) (2020-12-21)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.5.0...1.6.0)

**Closed issues:**

- New gem release required prior to Puppet 7 to resolve dependency issues [\#161](https://github.com/voxpupuli/facterdb/issues/161)
- FacterDB appears to not give a os.family for solaris 11 on facter 4 [\#158](https://github.com/voxpupuli/facterdb/issues/158)
- facterdb conflict [\#157](https://github.com/voxpupuli/facterdb/issues/157)

**Merged pull requests:**

- release 1.6.0 [\#163](https://github.com/voxpupuli/facterdb/pull/163) ([bastelfreak](https://github.com/bastelfreak))
- Archlinux: Update fact sets [\#162](https://github.com/voxpupuli/facterdb/pull/162) ([bastelfreak](https://github.com/bastelfreak))

## [1.5.0](https://rubygems.org/gems/facterdb/versions/1.5.0) (2020-11-19)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.4.0...1.5.0)

**Implemented enhancements:**

- add filter validation [\#19](https://github.com/voxpupuli/facterdb/issues/19)

**Merged pull requests:**

- Fixes a bug with generate\_filter\_str [\#160](https://github.com/voxpupuli/facterdb/pull/160) ([logicminds](https://github.com/logicminds))
- Fixes \#19 - add filter validation [\#159](https://github.com/voxpupuli/facterdb/pull/159) ([logicminds](https://github.com/logicminds))
- Remove pin on facter \< 4 [\#156](https://github.com/voxpupuli/facterdb/pull/156) ([sanfrancrisko](https://github.com/sanfrancrisko))
- Add ruby 2.5 and 2.7 testing [\#155](https://github.com/voxpupuli/facterdb/pull/155) ([DavidS](https://github.com/DavidS))

## [1.4.0](https://rubygems.org/gems/facterdb/versions/1.4.0) (2020-05-09)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.3.0...1.4.0)

**Merged pull requests:**

- Add Ubuntu 20.04 factset [\#154](https://github.com/voxpupuli/facterdb/pull/154) ([mmoll](https://github.com/mmoll))

## [1.3.0](https://rubygems.org/gems/facterdb/versions/1.3.0) (2020-04-15)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.2.0...1.3.0)

**Closed issues:**

- Raspbian support [\#135](https://github.com/voxpupuli/facterdb/issues/135)

**Merged pull requests:**

- Add Debian 10 facter 3.13/3.14 sets [\#152](https://github.com/voxpupuli/facterdb/pull/152) ([bastelfreak](https://github.com/bastelfreak))
- Pin to facter \< 4 to avoid automatic upgrade [\#151](https://github.com/voxpupuli/facterdb/pull/151) ([raphink](https://github.com/raphink))
- Adding facts from Solaris 11 x86 & SPARC [\#149](https://github.com/voxpupuli/facterdb/pull/149) ([genebean](https://github.com/genebean))
- AmazonLinux facts added [\#147](https://github.com/voxpupuli/facterdb/pull/147) ([bFekete](https://github.com/bFekete))
- Add facts for Raspbian 9 and 10; alter Rakefile to support Raspbian [\#136](https://github.com/voxpupuli/facterdb/pull/136) ([threepistons](https://github.com/threepistons))

## [1.2.0](https://rubygems.org/gems/facterdb/versions/1.2.0) (2020-01-08)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.1.0...1.2.0)

**Merged pull requests:**

- \[Arch Linux\] Set correct hostname, domain, fqdn [\#146](https://github.com/voxpupuli/facterdb/pull/146) ([dhoppe](https://github.com/dhoppe))
- drop json as runtime dependency [\#145](https://github.com/voxpupuli/facterdb/pull/145) ([bastelfreak](https://github.com/bastelfreak))
- add .vendor to .gitignore [\#144](https://github.com/voxpupuli/facterdb/pull/144) ([bastelfreak](https://github.com/bastelfreak))

## [1.1.0](https://rubygems.org/gems/facterdb/versions/1.1.0) (2020-01-07)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/1.0.0...1.1.0)

**Closed issues:**

- Please provider Gentoo facts for 3.14 [\#139](https://github.com/voxpupuli/facterdb/issues/139)
- Archlinux legacy facts missing in 3.x fact sets. [\#132](https://github.com/voxpupuli/facterdb/issues/132)

**Merged pull requests:**

- Add Gentoo 3.11 factset [\#143](https://github.com/voxpupuli/facterdb/pull/143) ([bastelfreak](https://github.com/bastelfreak))
- archlinux: set correct FQDN/hostname [\#142](https://github.com/voxpupuli/facterdb/pull/142) ([bastelfreak](https://github.com/bastelfreak))
- Add Fedora 30 facts for Facter 3.11 [\#141](https://github.com/voxpupuli/facterdb/pull/141) ([baurmatt](https://github.com/baurmatt))
- Add Gentoo facts for Facter 3.14 [\#140](https://github.com/voxpupuli/facterdb/pull/140) ([baurmatt](https://github.com/baurmatt))
- Add CentOS 8 facts [\#137](https://github.com/voxpupuli/facterdb/pull/137) ([traylenator](https://github.com/traylenator))

## [1.0.0](https://rubygems.org/gems/facterdb/versions/1.0.0) (2019-10-29)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.8.2...1.0.0)

**Fixed bugs:**

- IP address facts have disappeared [\#127](https://github.com/voxpupuli/facterdb/issues/127)

**Merged pull requests:**

- regenerate Archlinux / VZ 7 facts [\#133](https://github.com/voxpupuli/facterdb/pull/133) ([bastelfreak](https://github.com/bastelfreak))
- add VirtuozzoLinux 7 facts [\#131](https://github.com/voxpupuli/facterdb/pull/131) ([bastelfreak](https://github.com/bastelfreak))
- Add more Archlinux facts [\#130](https://github.com/voxpupuli/facterdb/pull/130) ([bastelfreak](https://github.com/bastelfreak))
- Ensure all fact sets contain the legacy networking facts [\#128](https://github.com/voxpupuli/facterdb/pull/128) ([rodjek](https://github.com/rodjek))

## [0.8.2](https://rubygems.org/gems/facterdb/versions/0.8.2) (2019-08-28)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.8.1...0.8.2)

**Fixed bugs:**

- Update removed selinux facts [\#124](https://github.com/voxpupuli/facterdb/issues/124)

**Merged pull requests:**

- Update RHEL based fact sets with default SELinux values [\#125](https://github.com/voxpupuli/facterdb/pull/125) ([rodjek](https://github.com/rodjek))

## [0.8.1](https://rubygems.org/gems/facterdb/versions/0.8.1) (2019-07-25)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.8.0...0.8.1)

**Merged pull requests:**

- Add fact sets for SLES15 [\#121](https://github.com/voxpupuli/facterdb/pull/121) ([rodjek](https://github.com/rodjek))

## [0.8.0](https://rubygems.org/gems/facterdb/versions/0.8.0) (2019-07-22)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.7.0...0.8.0)

**Closed issues:**

- solaris 10 facts are not found [\#115](https://github.com/voxpupuli/facterdb/issues/115)
- Debian 10 facts [\#102](https://github.com/voxpupuli/facterdb/issues/102)
- 3.11 facts for Debian Stretch and Ubuntu 18.04 are missing distro information [\#98](https://github.com/voxpupuli/facterdb/issues/98)
- Remove/move invalid factset files [\#78](https://github.com/voxpupuli/facterdb/issues/78)
- Remove duplicate default factset files [\#77](https://github.com/voxpupuli/facterdb/issues/77)
- Updated OpenBSD Facts [\#71](https://github.com/voxpupuli/facterdb/issues/71)
- FreeBSD Support [\#51](https://github.com/voxpupuli/facterdb/issues/51)
- Add LinuxMint Facts [\#41](https://github.com/voxpupuli/facterdb/issues/41)
- Facts for archlinux release 4 are missing. [\#37](https://github.com/voxpupuli/facterdb/issues/37)
- Consider adding the os::distro fact [\#36](https://github.com/voxpupuli/facterdb/issues/36)

**Merged pull requests:**

- Add fact sets for Debian 10 [\#119](https://github.com/voxpupuli/facterdb/pull/119) ([rodjek](https://github.com/rodjek))
- Improve test coverage [\#118](https://github.com/voxpupuli/facterdb/pull/118) ([rodjek](https://github.com/rodjek))
- Update Windows factsets [\#117](https://github.com/voxpupuli/facterdb/pull/117) ([rodjek](https://github.com/rodjek))
- Added and updated Solaris 10 factsets [\#116](https://github.com/voxpupuli/facterdb/pull/116) ([sirinek](https://github.com/sirinek))
- Update OSX 10.11 - 10.14 factsets [\#113](https://github.com/voxpupuli/facterdb/pull/113) ([rodjek](https://github.com/rodjek))
- Update SLES 11 & 12 factsets [\#112](https://github.com/voxpupuli/facterdb/pull/112) ([rodjek](https://github.com/rodjek))
- Change table rake task to update README.md [\#111](https://github.com/voxpupuli/facterdb/pull/111) ([rodjek](https://github.com/rodjek))
- Update RHEL based factsets [\#110](https://github.com/voxpupuli/facterdb/pull/110) ([rodjek](https://github.com/rodjek))
- \(\#71\) Add OpenBSD 6.4 factsets [\#109](https://github.com/voxpupuli/facterdb/pull/109) ([rodjek](https://github.com/rodjek))
- \(\#98\) Update Debian & Ubuntu factsets [\#108](https://github.com/voxpupuli/facterdb/pull/108) ([rodjek](https://github.com/rodjek))
- Properly split and sort facter versions [\#107](https://github.com/voxpupuli/facterdb/pull/107) ([rodjek](https://github.com/rodjek))
- \(\#41\) Add factsets for linuxmint 18 & 19 [\#106](https://github.com/voxpupuli/facterdb/pull/106) ([rodjek](https://github.com/rodjek))
- \(\#37\) Update Archlinux factsets [\#105](https://github.com/voxpupuli/facterdb/pull/105) ([rodjek](https://github.com/rodjek))
- Add more FreeBSD facts [\#104](https://github.com/voxpupuli/facterdb/pull/104) ([smortex](https://github.com/smortex))
- add missing rubygem-bundler package for FreeBSD [\#103](https://github.com/voxpupuli/facterdb/pull/103) ([olevole](https://github.com/olevole))
- Missing facts [\#99](https://github.com/voxpupuli/facterdb/pull/99) ([seanmil](https://github.com/seanmil))
- Add CentOS e.a. facts from facter 3.11 [\#87](https://github.com/voxpupuli/facterdb/pull/87) ([tdevelioglu](https://github.com/tdevelioglu))
- Explicitly use bash not sh [\#81](https://github.com/voxpupuli/facterdb/pull/81) ([bodgit](https://github.com/bodgit))
- OpenBSD 6.2 & 6.3 facts [\#80](https://github.com/voxpupuli/facterdb/pull/80) ([bodgit](https://github.com/bodgit))
- \(\#77\)\(\#78\)  Add default factset tests and fix failures [\#79](https://github.com/voxpupuli/facterdb/pull/79) ([glennsarti](https://github.com/glennsarti))

## [0.7.0](https://rubygems.org/gems/facterdb/versions/0.7.0) (2019-07-02)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.6.0...0.7.0)

**Merged pull requests:**

- Add facts for aarch64. [\#100](https://github.com/voxpupuli/facterdb/pull/100) ([ralimi](https://github.com/ralimi))

## [0.6.0](https://rubygems.org/gems/facterdb/versions/0.6.0) (2018-12-13)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.5.2...0.6.0)

**Implemented enhancements:**

- Rework of Lots of Puppet 5 facter additions [\#95](https://github.com/voxpupuli/facterdb/pull/95) ([Dan33l](https://github.com/Dan33l))
- Add Gentoo facts for Facter 2.5 and fix Travis CI [\#93](https://github.com/voxpupuli/facterdb/pull/93) ([baurmatt](https://github.com/baurmatt))
- Update Fedora facts [\#89](https://github.com/voxpupuli/facterdb/pull/89) ([blackknight36](https://github.com/blackknight36))
- Add facter 3.11 facts for Debian 9 and Ubuntu 18.04 [\#88](https://github.com/voxpupuli/facterdb/pull/88) ([tobias-urdin](https://github.com/tobias-urdin))
- Updated fedora facts for f26 and f27 [\#85](https://github.com/voxpupuli/facterdb/pull/85) ([timhughes](https://github.com/timhughes))

**Fixed bugs:**

- Git+SSH Url broken Travis CI [\#92](https://github.com/voxpupuli/facterdb/issues/92)
- Code doesnt handle facter point versions with 2 digits  [\#83](https://github.com/voxpupuli/facterdb/issues/83)
- Rakefile: Set config.projet for github\_changelog\_generator [\#97](https://github.com/voxpupuli/facterdb/pull/97) ([raphink](https://github.com/raphink))
- fixes \#83 changes the way factor version in paths is calculated [\#84](https://github.com/voxpupuli/facterdb/pull/84) ([timhughes](https://github.com/timhughes))

**Closed issues:**

- facts/2.5/fedora-28-x86\_64.facts broken [\#91](https://github.com/voxpupuli/facterdb/issues/91)
- Add facter 2.5 Gentoo facts [\#90](https://github.com/voxpupuli/facterdb/issues/90)

## [0.5.2](https://rubygems.org/gems/facterdb/versions/0.5.2) (2018-04-30)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.5.1...0.5.2)

**Merged pull requests:**

- add Ubuntu 18.04 facts [\#82](https://github.com/voxpupuli/facterdb/pull/82) ([bastelfreak](https://github.com/bastelfreak))
- \(maint\) Add `rake table` task + update README.md + better Windows detection [\#76](https://github.com/voxpupuli/facterdb/pull/76) ([glennsarti](https://github.com/glennsarti))
- Added Solaris 10 facts on Facter 3.9 [\#75](https://github.com/voxpupuli/facterdb/pull/75) ([sirinek](https://github.com/sirinek))

## [0.5.1](https://rubygems.org/gems/facterdb/versions/0.5.1) (2018-03-06)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.5.0...0.5.1)

**Merged pull requests:**

- AIX 7.1 legacy facts [\#74](https://github.com/voxpupuli/facterdb/pull/74) ([TJM](https://github.com/TJM))
- Fix Archlinux support / update archlinux facts [\#73](https://github.com/voxpupuli/facterdb/pull/73) ([bastelfreak](https://github.com/bastelfreak))
- Add AIX 7.1 powerpc [\#72](https://github.com/voxpupuli/facterdb/pull/72) ([TJM](https://github.com/TJM))

## [0.5.0](https://rubygems.org/gems/facterdb/versions/0.5.0) (2017-12-14)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.4.1...0.5.0)

**Closed issues:**

- create new release [\#65](https://github.com/voxpupuli/facterdb/issues/65)

**Merged pull requests:**

- add freebsd\_11 facts [\#69](https://github.com/voxpupuli/facterdb/pull/69) ([b4ldr](https://github.com/b4ldr))
- add freebsd 10 facts for facter 2.5 and 3.9 [\#68](https://github.com/voxpupuli/facterdb/pull/68) ([b4ldr](https://github.com/b4ldr))
- openSUSE Support [\#63](https://github.com/voxpupuli/facterdb/pull/63) ([genebean](https://github.com/genebean))

## [0.4.1](https://rubygems.org/gems/facterdb/versions/0.4.1) (2017-10-25)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.4.0...0.4.1)

## [0.4.0](https://rubygems.org/gems/facterdb/versions/0.4.0) (2017-10-24)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.3.12...0.4.0)

**Implemented enhancements:**

- Allow loading of external fact hashes [\#62](https://github.com/voxpupuli/facterdb/pull/62) ([logicminds](https://github.com/logicminds))
- Improve FreeBSD Support [\#60](https://github.com/voxpupuli/facterdb/pull/60) ([xaque208](https://github.com/xaque208))
- Add facts for Amazon Linux 2017.03 [\#56](https://github.com/voxpupuli/facterdb/pull/56) ([pillarsdotnet](https://github.com/pillarsdotnet))
- Add missing facts for Fedora 20, 21, and 26 [\#50](https://github.com/voxpupuli/facterdb/pull/50) ([blackknight36](https://github.com/blackknight36))
- Facter 3.8 fact sets [\#48](https://github.com/voxpupuli/facterdb/pull/48) ([rodjek](https://github.com/rodjek))

**Fixed bugs:**

- Update Windows Facter 3.x sets with legacy facts [\#64](https://github.com/voxpupuli/facterdb/pull/64) ([rodjek](https://github.com/rodjek))
- fix facter 2.x facts for Debian 9 [\#52](https://github.com/voxpupuli/facterdb/pull/52) ([mmoll](https://github.com/mmoll))

**Closed issues:**

- Add facts for Amazon Linux  [\#57](https://github.com/voxpupuli/facterdb/issues/57)
- Fact package\_provider is missing [\#49](https://github.com/voxpupuli/facterdb/issues/49)
- allow loading of external fact hashes [\#27](https://github.com/voxpupuli/facterdb/issues/27)

## [0.3.12](https://rubygems.org/gems/facterdb/versions/0.3.12) (2017-07-27)

[Full Changelog](https://github.com/voxpupuli/facterdb/compare/0.3.11...0.3.12)

**Closed issues:**

- Add support for Facter 2.5 [\#47](https://github.com/voxpupuli/facterdb/issues/47)
- Add support for facter 2.5  [\#45](https://github.com/voxpupuli/facterdb/issues/45)
- Add Debian Stretch [\#43](https://github.com/voxpupuli/facterdb/issues/43)
- Release new version [\#40](https://github.com/voxpupuli/facterdb/issues/40)
- support for more windows editions [\#30](https://github.com/voxpupuli/facterdb/issues/30)

**Merged pull requests:**

- Backfill missing 2.x and 3.x facts for supported operating systems [\#46](https://github.com/voxpupuli/facterdb/pull/46) ([rodjek](https://github.com/rodjek))
- Adds Mint-18.1 Facts [\#42](https://github.com/voxpupuli/facterdb/pull/42) ([petems](https://github.com/petems))

**Implemented enhancements:**

- Backfill missing 2.x and 3.x facts for supported operating systems [\#46](https://github.com/camptocamp/facterdb/pulls/46)
- Adds Mint-18.1 facts [\#42](https://github.com/camptocamp/facterdb/pulls/42)
- Use rvm 2.3 for unit tests

## [0.3.11]((https://rubygems.org/gems/facterdb/versions/0.3.11) (2017-06-23)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.10...0.3.11)

**Implemented enhancements:**

- Add Virtuozzo PCS 6 x86_64 support
- Add CentOS from facter 3.6

## [0.3.10]((https://rubygems.org/gems/facterdb/versions/0.3.10) (2017-03-08)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.9...0.3.10)

**Implemented enhancements:**

- Add SLES 12 support

## [0.3.9]((https://rubygems.org/gems/facterdb/versions/0.3.9) (2017-02-07)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.8...0.3.9)

**Implemented enhancements:**

- Add OpenBSD 6.0 support

## [0.3.8]((https://rubygems.org/gems/facterdb/versions/0.3.8) (2016-10-15)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.7...0.3.8)

**Implemented enhancements:**

- Add Fedora 24 support

## [0.3.7]((https://rubygems.org/gems/facterdb/versions/0.3.7) (2016-10-06)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.6...0.3.7)

**Implemented enhancements:**

- Add AIX facts for facter 3.2

## [0.3.6]((https://rubygems.org/gems/facterdb/versions/0.3.6) (2016-08-04)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.5...0.3.6)

**Implemented enhancements:**

- Add facts for facter 3.3
- Use --show-legacy for facter 3

## [0.3.5](https://rubygems.org/gems/facterdb/versions/0.3.5) (2016-05-02)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.4...0.3.5)

**Implemented enhancements:**

- Add facts for OpenBSD 5.8 and OpenBSD 5.9

## [0.3.4](https://rubygems.org/gems/facterdb/versions/0.3.4) (2016-04-11)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.3...0.3.4)

**Implemented enhancements:**

- Add facts for Fedora 22 and Fedora 23

## [0.3.3](https://rubygems.org/gems/facterdb/versions/0.3.3) (2016-03-30)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.2...0.3.3)

**Implemented enhancements:**

- Add facts for Ubuntu 16.04

## [0.3.2](https://rubygems.org/gems/facterdb/versions/0.3.2) (2016-03-25)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.1...0.3.2)

**Implemented enhancements:**

- Add facts for Windows 2012 r2 and Windows 7

## [0.3.1](https://rubygems.org/gems/facterdb/versions/0.3.1) (2016-01-06)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.0...0.3.1)

**Implemented enhancements:**

- Add facts for OSX 10.10

## [0.3.0](https://rubygems.org/gems/facterdb/versions/0.3.0) (2015-11-05)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.2.2...0.3.0)

**Implemented enhancements:**

- New function: get\_facts
- Deprecated function: get\_os\_facts

## [0.2.2](https://rubygems.org/gems/facterdb/versions/0.2.2) (2015-11-05)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.2.1...0.2.2)

**Implemented enhancements:**

- Add facts for Ubuntu 15.10

## [0.2.1](https://rubygems.org/gems/facterdb/versions/0.2.1) (2015-08-31)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.2.0...0.2.1)

**Fixed bugs:**

- Tag 0.2.0 does not point to the right commit... [\#13](https://github.com/camptocamp/facterdb/issues/13)

## [0.2.0](https://rubygems.org/gems/facterdb/versions/0.2.0) (2015-08-31)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.1.0...0.2.0)

**Implemented enhancements:**

- Add CLI [\#9](https://github.com/camptocamp/facterdb/issues/9)
- Allow Hash or String for filter [\#8](https://github.com/camptocamp/facterdb/issues/8)

**Fixed bugs:**

- Fix project homepage [\#10](https://github.com/camptocamp/facterdb/issues/10)
- Hash keys should be symbolized [\#11](https://github.com/camptocamp/facterdb/pull/11) ([mcanevet](https://github.com/mcanevet))

## [0.1.0](https://rubygems.org/gems/facterdb/versions/0.1.0) (2015-08-27)
[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.0.1...0.1.0)

**Implemented enhancements:**

- Add missing facts [\#3](https://github.com/camptocamp/facterdb/issues/3)
- No need for include with self.\# [\#2](https://github.com/camptocamp/facterdb/pull/2) ([raphink](https://github.com/raphink))
- Use jgrep to filter out OS facts [\#1](https://github.com/camptocamp/facterdb/pull/1) ([raphink](https://github.com/raphink))

**Fixed bugs:**

- Use a relative factsdir for the lib [\#4](https://github.com/camptocamp/facterdb/pull/4) ([raphink](https://github.com/raphink))

## [0.0.1](https://rubygems.org/gems/facterdb/versions/0.0.1) (2015-05-29)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
