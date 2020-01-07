# Changelog

## [1.1.0](https://rubygems.org/gems/facterdb/versions/1.1.0) (2020-01-07)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/1.0.0...1.1.0)

**Closed issues:**

- Please provider Gentoo facts for 3.14 [\#139](https://github.com/camptocamp/facterdb/issues/139)
- Archlinux legacy facts missing in 3.x fact sets. [\#132](https://github.com/camptocamp/facterdb/issues/132)

**Merged pull requests:**

- Add Gentoo 3.11 factset [\#143](https://github.com/camptocamp/facterdb/pull/143) ([bastelfreak](https://github.com/bastelfreak))
- archlinux: set correct FQDN/hostname [\#142](https://github.com/camptocamp/facterdb/pull/142) ([bastelfreak](https://github.com/bastelfreak))
- Add Fedora 30 facts for Facter 3.11 [\#141](https://github.com/camptocamp/facterdb/pull/141) ([baurmatt](https://github.com/baurmatt))
- Add Gentoo facts for Facter 3.14 [\#140](https://github.com/camptocamp/facterdb/pull/140) ([baurmatt](https://github.com/baurmatt))
- Add CentOS 8 facts [\#137](https://github.com/camptocamp/facterdb/pull/137) ([traylenator](https://github.com/traylenator))

## [1.0.0](https://rubygems.org/gems/facterdb/versions/1.0.0) (2019-10-29)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.8.2...1.0.0)

**Fixed bugs:**

- IP address facts have disappeared [\#127](https://github.com/camptocamp/facterdb/issues/127)

**Merged pull requests:**

- regenerate Archlinux / VZ 7 facts [\#133](https://github.com/camptocamp/facterdb/pull/133) ([bastelfreak](https://github.com/bastelfreak))
- add VirtuozzoLinux 7 facts [\#131](https://github.com/camptocamp/facterdb/pull/131) ([bastelfreak](https://github.com/bastelfreak))
- Add more Archlinux facts [\#130](https://github.com/camptocamp/facterdb/pull/130) ([bastelfreak](https://github.com/bastelfreak))
- Ensure all fact sets contain the legacy networking facts [\#128](https://github.com/camptocamp/facterdb/pull/128) ([rodjek](https://github.com/rodjek))

## [0.8.2](https://rubygems.org/gems/facterdb/versions/0.8.2) (2019-08-28)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.8.1...0.8.2)

**Fixed bugs:**

- Update removed selinux facts [\#124](https://github.com/camptocamp/facterdb/issues/124)

**Merged pull requests:**

- Update RHEL based fact sets with default SELinux values [\#125](https://github.com/camptocamp/facterdb/pull/125) ([rodjek](https://github.com/rodjek))

## [0.8.1](https://rubygems.org/gems/facterdb/versions/0.8.1) (2019-07-25)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.8.0...0.8.1)

**Merged pull requests:**

- Add fact sets for SLES15 [\#121](https://github.com/camptocamp/facterdb/pull/121) ([rodjek](https://github.com/rodjek))

## [0.8.0](https://rubygems.org/gems/facterdb/versions/0.8.0) (2019-07-22)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.7.0...0.8.0)

**Closed issues:**

- solaris 10 facts are not found [\#115](https://github.com/camptocamp/facterdb/issues/115)
- Debian 10 facts [\#102](https://github.com/camptocamp/facterdb/issues/102)
- 3.11 facts for Debian Stretch and Ubuntu 18.04 are missing distro information [\#98](https://github.com/camptocamp/facterdb/issues/98)
- Remove/move invalid factset files [\#78](https://github.com/camptocamp/facterdb/issues/78)
- Remove duplicate default factset files [\#77](https://github.com/camptocamp/facterdb/issues/77)
- Updated OpenBSD Facts [\#71](https://github.com/camptocamp/facterdb/issues/71)
- FreeBSD Support [\#51](https://github.com/camptocamp/facterdb/issues/51)
- Add LinuxMint Facts [\#41](https://github.com/camptocamp/facterdb/issues/41)
- Facts for archlinux release 4 are missing. [\#37](https://github.com/camptocamp/facterdb/issues/37)
- Consider adding the os::distro fact [\#36](https://github.com/camptocamp/facterdb/issues/36)

**Merged pull requests:**

- Add fact sets for Debian 10 [\#119](https://github.com/camptocamp/facterdb/pull/119) ([rodjek](https://github.com/rodjek))
- Improve test coverage [\#118](https://github.com/camptocamp/facterdb/pull/118) ([rodjek](https://github.com/rodjek))
- Update Windows factsets [\#117](https://github.com/camptocamp/facterdb/pull/117) ([rodjek](https://github.com/rodjek))
- Added and updated Solaris 10 factsets [\#116](https://github.com/camptocamp/facterdb/pull/116) ([sirinek](https://github.com/sirinek))
- Update OSX 10.11 - 10.14 factsets [\#113](https://github.com/camptocamp/facterdb/pull/113) ([rodjek](https://github.com/rodjek))
- Update SLES 11 & 12 factsets [\#112](https://github.com/camptocamp/facterdb/pull/112) ([rodjek](https://github.com/rodjek))
- Change table rake task to update README.md [\#111](https://github.com/camptocamp/facterdb/pull/111) ([rodjek](https://github.com/rodjek))
- Update RHEL based factsets [\#110](https://github.com/camptocamp/facterdb/pull/110) ([rodjek](https://github.com/rodjek))
- \(\#71\) Add OpenBSD 6.4 factsets [\#109](https://github.com/camptocamp/facterdb/pull/109) ([rodjek](https://github.com/rodjek))
- \(\#98\) Update Debian & Ubuntu factsets [\#108](https://github.com/camptocamp/facterdb/pull/108) ([rodjek](https://github.com/rodjek))
- Properly split and sort facter versions [\#107](https://github.com/camptocamp/facterdb/pull/107) ([rodjek](https://github.com/rodjek))
- \(\#41\) Add factsets for linuxmint 18 & 19 [\#106](https://github.com/camptocamp/facterdb/pull/106) ([rodjek](https://github.com/rodjek))
- \(\#37\) Update Archlinux factsets [\#105](https://github.com/camptocamp/facterdb/pull/105) ([rodjek](https://github.com/rodjek))
- Add more FreeBSD facts [\#104](https://github.com/camptocamp/facterdb/pull/104) ([smortex](https://github.com/smortex))
- add missing rubygem-bundler package for FreeBSD [\#103](https://github.com/camptocamp/facterdb/pull/103) ([olevole](https://github.com/olevole))
- Missing facts [\#99](https://github.com/camptocamp/facterdb/pull/99) ([seanmil](https://github.com/seanmil))
- Add CentOS e.a. facts from facter 3.11 [\#87](https://github.com/camptocamp/facterdb/pull/87) ([tdevelioglu](https://github.com/tdevelioglu))
- Explicitly use bash not sh [\#81](https://github.com/camptocamp/facterdb/pull/81) ([bodgit](https://github.com/bodgit))
- OpenBSD 6.2 & 6.3 facts [\#80](https://github.com/camptocamp/facterdb/pull/80) ([bodgit](https://github.com/bodgit))
- \(\#77\)\(\#78\)  Add default factset tests and fix failures [\#79](https://github.com/camptocamp/facterdb/pull/79) ([glennsarti](https://github.com/glennsarti))

## [0.7.0](https://rubygems.org/gems/facterdb/versions/0.7.0) (2019-07-02)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.6.0...0.7.0)

**Merged pull requests:**

- Add facts for aarch64. [\#100](https://github.com/camptocamp/facterdb/pull/100) ([ralimi](https://github.com/ralimi))

## [0.6.0](https://rubygems.org/gems/facterdb/versions/0.6.0) (2018-12-13)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.5.2...0.6.0)

**Implemented enhancements:**

- Rework of Lots of Puppet 5 facter additions [\#95](https://github.com/camptocamp/facterdb/pull/95) ([Dan33l](https://github.com/Dan33l))
- Add Gentoo facts for Facter 2.5 and fix Travis CI [\#93](https://github.com/camptocamp/facterdb/pull/93) ([baurmatt](https://github.com/baurmatt))
- Update Fedora facts [\#89](https://github.com/camptocamp/facterdb/pull/89) ([blackknight36](https://github.com/blackknight36))
- Add facter 3.11 facts for Debian 9 and Ubuntu 18.04 [\#88](https://github.com/camptocamp/facterdb/pull/88) ([tobias-urdin](https://github.com/tobias-urdin))
- Updated fedora facts for f26 and f27 [\#85](https://github.com/camptocamp/facterdb/pull/85) ([timhughes](https://github.com/timhughes))

**Fixed bugs:**

- Git+SSH Url broken Travis CI [\#92](https://github.com/camptocamp/facterdb/issues/92)
- Code doesnt handle facter point versions with 2 digits  [\#83](https://github.com/camptocamp/facterdb/issues/83)
- Rakefile: Set config.projet for github\_changelog\_generator [\#97](https://github.com/camptocamp/facterdb/pull/97) ([raphink](https://github.com/raphink))
- fixes \#83 changes the way factor version in paths is calculated [\#84](https://github.com/camptocamp/facterdb/pull/84) ([timhughes](https://github.com/timhughes))

**Closed issues:**

- facts/2.5/fedora-28-x86\_64.facts broken [\#91](https://github.com/camptocamp/facterdb/issues/91)
- Add facter 2.5 Gentoo facts [\#90](https://github.com/camptocamp/facterdb/issues/90)

## [0.5.2](https://rubygems.org/gems/facterdb/versions/0.5.2) (2018-04-30)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.5.1...0.5.2)

**Merged pull requests:**

- add Ubuntu 18.04 facts [\#82](https://github.com/camptocamp/facterdb/pull/82) ([bastelfreak](https://github.com/bastelfreak))
- \(maint\) Add `rake table` task + update README.md + better Windows detection [\#76](https://github.com/camptocamp/facterdb/pull/76) ([glennsarti](https://github.com/glennsarti))
- Added Solaris 10 facts on Facter 3.9 [\#75](https://github.com/camptocamp/facterdb/pull/75) ([sirinek](https://github.com/sirinek))

## [0.5.1](https://rubygems.org/gems/facterdb/versions/0.5.1) (2018-03-06)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.5.0...0.5.1)

**Merged pull requests:**

- AIX 7.1 legacy facts [\#74](https://github.com/camptocamp/facterdb/pull/74) ([TJM](https://github.com/TJM))
- Fix Archlinux support / update archlinux facts [\#73](https://github.com/camptocamp/facterdb/pull/73) ([bastelfreak](https://github.com/bastelfreak))
- Add AIX 7.1 powerpc [\#72](https://github.com/camptocamp/facterdb/pull/72) ([TJM](https://github.com/TJM))

## [0.5.0](https://rubygems.org/gems/facterdb/versions/0.5.0) (2017-12-14)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.4.1...0.5.0)

**Closed issues:**

- create new release [\#65](https://github.com/camptocamp/facterdb/issues/65)

**Merged pull requests:**

- Release prep for 0.5.0 [\#70](https://github.com/camptocamp/facterdb/pull/70) ([DavidS](https://github.com/DavidS))
- add freebsd\_11 facts [\#69](https://github.com/camptocamp/facterdb/pull/69) ([b4ldr](https://github.com/b4ldr))
- add freebsd 10 facts for facter 2.5 and 3.9 [\#68](https://github.com/camptocamp/facterdb/pull/68) ([b4ldr](https://github.com/b4ldr))
- openSUSE Support [\#63](https://github.com/camptocamp/facterdb/pull/63) ([genebean](https://github.com/genebean))

## [0.4.1](https://rubygems.org/gems/facterdb/versions/0.4.1) (2017-10-25)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.4.0...0.4.1)

**Implemented enhancements:**

- Release prep for 0.4.0 [\#66](https://github.com/camptocamp/facterdb/pull/66) ([DavidS](https://github.com/DavidS))

## [0.4.0](https://rubygems.org/gems/facterdb/versions/0.4.0) (2017-10-24)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.12...0.4.0)

**Implemented enhancements:**

- Allow loading of external fact hashes [\#62](https://github.com/camptocamp/facterdb/pull/62) ([logicminds](https://github.com/logicminds))
- Improve FreeBSD Support [\#60](https://github.com/camptocamp/facterdb/pull/60) ([xaque208](https://github.com/xaque208))
- Add facts for Amazon Linux 2017.03 [\#56](https://github.com/camptocamp/facterdb/pull/56) ([pillarsdotnet](https://github.com/pillarsdotnet))
- Add missing facts for Fedora 20, 21, and 26 [\#50](https://github.com/camptocamp/facterdb/pull/50) ([blackknight36](https://github.com/blackknight36))
- Facter 3.8 fact sets [\#48](https://github.com/camptocamp/facterdb/pull/48) ([rodjek](https://github.com/rodjek))

**Fixed bugs:**

- Update Windows Facter 3.x sets with legacy facts [\#64](https://github.com/camptocamp/facterdb/pull/64) ([rodjek](https://github.com/rodjek))
- fix facter 2.x facts for Debian 9 [\#52](https://github.com/camptocamp/facterdb/pull/52) ([mmoll](https://github.com/mmoll))

**Closed issues:**

- Add facts for Amazon Linux  [\#57](https://github.com/camptocamp/facterdb/issues/57)
- Fact package\_provider is missing [\#49](https://github.com/camptocamp/facterdb/issues/49)
- allow loading of external fact hashes [\#27](https://github.com/camptocamp/facterdb/issues/27)

## [0.3.12](https://rubygems.org/gems/facterdb/versions/0.3.12) (2017-07-27)

[Full Changelog](https://github.com/camptocamp/facterdb/compare/0.3.11...0.3.12)

**Closed issues:**

- Add support for Facter 2.5 [\#47](https://github.com/camptocamp/facterdb/issues/47)
- Add support for facter 2.5  [\#45](https://github.com/camptocamp/facterdb/issues/45)
- Add Debian Stretch [\#43](https://github.com/camptocamp/facterdb/issues/43)
- Release new version [\#40](https://github.com/camptocamp/facterdb/issues/40)
- support for more windows editions [\#30](https://github.com/camptocamp/facterdb/issues/30)

**Merged pull requests:**

- Backfill missing 2.x and 3.x facts for supported operating systems [\#46](https://github.com/camptocamp/facterdb/pull/46) ([rodjek](https://github.com/rodjek))
- Adds Mint-18.1 Facts [\#42](https://github.com/camptocamp/facterdb/pull/42) ([petems](https://github.com/petems))

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
