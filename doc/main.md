facterdb
========

[![License](https://img.shields.io/github/license/voxpupuli/facterdb.svg)](https://github.com/voxpupuli/facterdb/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/facterdb/actions/workflows/test.yml/badge.svg)](https://github.com/voxpupuli/facterdb/actions/workflows/test.yml)
[![Release](https://github.com/voxpupuli/facterdb/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/facterdb/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/facterdb.svg)](https://rubygems.org/gems/facterdb)
[![RubyGem Downloads](https://img.shields.io/gem/dt/facterdb.svg)](https://rubygems.org/gems/facterdb)
[![Donated by Camptocamp](https://img.shields.io/badge/donated%20by-camptocamp-fb7047.svg)](#transfer-notice)

A Gem that contains a lot of facts for a lot of Operating Systems.

![FacterDB](images/facterdb.png)

## GEM Documentation

Start with the {file:README.md}.

## Included Factsets

There may be Factsets available for any combination of `Operating System`, `Architecture` (i.e. `i386`, `x86_64`, `arm64`), and `Facter Version`.

The list of factsets is available in several different formats:

- {file:database/table.md Table of Operating Systems and Facter Versions} - this is the table that was formerly available in the README.
- {file:database/list_arch_os_facter.md List: Grouped by Architecture -> Operating System}
- {file:database/list_facter_os_arch.md List: Grouped by Facter Version -> Operating System}
- {file:database/list_os_arch_facter.md List: Grouped by Operating System -> Architecture}
- {file:database/list_os_facter_arch.md List: Grouped by Operating System -> Facter Version}

Starting with version 1.28.0 (May 2024), check [RubyDoc](https://www.rubydoc.info/gems/facterdb/) for Factsets included in each released gem.

