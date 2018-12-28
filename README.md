# Wrapper Module for iptables and firewalld Firewalls

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/jstuart/puppet-local_fw/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/jstuart/puppet-local_fw.svg?branch=master)](https://travis-ci.org/jstuart/puppet-local_fw)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with local_fw](#setup)
    * [What local_fw affects](#what-local_fw-affects)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module wraps the [firewall](https://forge.puppet.com/puppetlabs/firewall) and [firewalld](https://forge.puppet.com/crayfishx/firewalld) Puppet modules, abstracting the type of firewall running on the system.

The goal is to allow other modules to specify the firewall rule they require, and let this module worry about the specifics of getting it setup.

## Setup

### What local_fw affects

This module can manage the following firewall types on EL6 and EL7 platforms

* iptables (via [firewall](https://forge.puppet.com/puppetlabs/firewall) on EL6 and EL7)
* firewalld (via [firewalld](https://forge.puppet.com/crayfishx/firewalld) on EL7)

### Setup Requirements

This module requires the following modules:
* The [stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib) Puppet library (4.25.1+).
* The [firewall](https://forge.puppet.com/puppetlabs/firewall) Puppet library for the management of iptables (optional if not using iptables).
* The [firewalld](https://forge.puppet.com/crayfishx/firewalld) Puppet library for the management of firewalld on EL7 (optional if not using firewalld).

## Usage

Configuration options are all provided in the `local_fw::globals` class.  Including the `local_fw` class will cause the actual management to occur.

## Limitations

This module is REALLY basic and at this point only supports rules the consist of an action (e.g. accept, reject), a protocol, and optionally a port.  IPV6 support is limited to turning iptables on or off based on system support for IPV6 and an optionally specified target state.

Unit testing is really just limited to compilation at this point.

## Development

Please feel free to submit issues or contribute.

## License

The MIT License (MIT)

Copyright 2018 James Stuart

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

