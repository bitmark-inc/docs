---
title: Run a Node
keywords: node
last_updated: 
sidebar: mydoc_sidebar
permalink: /register-and-control-data/run-a-node
folder: register-and-control-data
---

# Run a Node

A full-node of bitmarkd consists of a `bitmarkd`, a `recorderd`, a payment system, a `litecoind`, and a `bitcoind`. The `bitmarkd` service  verifies and records transactions on the Bitmark blockchain while the `recorderd` service computes the Bitmark proof-of-work algorithm that allows nodes to compete to win blocks on the Bitmark blockchain. 

This tutorial explains how to set up the `bitmarkd` and/or the `recorderd` services by hand.

## Prerequisites

* You must install the go language package for your system.
* You must configure environmental variables for the go system.
* You must install the ZMQ4 and Argon2 libraries.

## Installing the Prerequisite Packages

Installing the required packages requires specific commands on Debian, FreeBSD, macOS, and Ubuntu.

### Installing Packages on Debian

_Tested on Stretch (Debian 9)._

First, ensure that the system has access to both the current version of Debian (`stable`) and `testing`.
~~~
root@debian-bitmarkd:/# cat /etc/apt/sources.list.d/stable.list
deb     http://ftp.de.debian.org/debian/    stable main contrib non-free
deb-src http://ftp.de.debian.org/debian/    stable main contrib non-free
deb     http://security.debian.org/         stable/updates  main contrib non-free

root@debian-bitmarkd:/# cat /etc/apt/sources.list.d/testing.list
deb     http://ftp.de.debian.org/debian/    testing main contrib non-free
deb-src http://ftp.de.debian.org/debian/    testing main contrib non-free
deb     http://security.debian.org/         testing/updates  main contrib non-free
~~~

Now. install `libargon2` from `testing`:
```shell
    $ apt-get -t testing install libargon2-dev libargon2-1
```

For the other packages, install from `stable` or `testing` as you prefer; both versions work:
```shell
    $ apt install uuid-dev libzmq3-dev
```
### Installing Packages on FreeBSD

```shell
    $ pkg install libzmq4 libargon2
```

### Installing Packages on macOS

_Be sure that Homebrew is installed correctly before beginning._

Then:
```shell
    $ brew tap bitmark-inc/bitmark
    $ brew install argon2
    $ brew install zeromq43
```

### Installing Packages on Ubuntu

_Tested on Ubuntu 18.04._

```shell
    $ apt install libargon2-0-dev uuid-dev libzmq3-dev
```

## Downloading and Installing a Bitmark Node

Download the Bitmark Node repository using the `git` command:
```shell
    $ git clone https://github.com/bitmark-inc/bitmarkd
```
Afterward, compile the repo using `go`. This process requires that the Go installation be 1.12 or later, as the build process uses Go Modules.

```shell
    $ cd bitmarkd
    $ go install -v ./...
```

## Setting Up and Running a Bitmark Node

Ensure that the `${HOME}/go/bin` directory is part of your shell's `${PATH}` before continuing.

The commands below assume you checked out and compiled your Bitmark Node into the ${HOME}/bitmarkd directory.

### Setting up and running `bitmarkd`

Create the configuration directory and copy the sample configuration:

```shell
    $ mkdir -p ~/.config/bitmarkd
    $ cp ~/bitmarkd/command/bitmarkd/bitmarkd.conf.sample  ~/.config/bitmarkd/bitmarkd.conf
```

Afterwards, edit the `bitmarkd.conf` to set up appropriate IP addresses, ports, and local bitcoin testnet connection. The sample configuration has some embedded instructions for quick setup, and only a few items near the beginning of the file need to be changed for basic use.

```shell
    $ ${EDITOR} ~/.config/bitmarkd/bitmarkd.conf
```

Generate key files and certificates:

```shell
    $ bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" gen-peer-identity "${HOME}/.config/bitmarkd/
    $ bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" gen-rpc-cert "${HOME}/.config/bitmarkd/
    $ bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" gen-proof-identity "${HOME}/.config/bitmarkd/
```

Finally, start the program.

```
    $ bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" start
```

For more information on `bitmarkd` sub-commands, run the following command:
```
    $ bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" help
```

### Setting up and running `recorderd`

`recorderd` is the mining program for the Bitmark Property System, which can optionally be run to support the Bitmark blockchain (and to earn bitmarks on blocks). 

Setting up `recorderd` is similar to setting up `bitmarkd`.

First, setup and edit your configuration file. For mining using the local `bitmarkd`, the sample configuration should work without changes.

```
mkdir -p ~/.config/recorderd
cp ~/bitmarkd/command/recorderd/recorderd.conf.sample  ~/.config/recorderd/recorderd.conf
${EDITOR} ~/.config/recorderd/recorderd.conf
```

Generate key files and certificates:

```
    $ recorderd --config-file="${HOME}/.config/recorderd/recorderd.conf" generate-identity "${HOME}/.config/recorderd/
```

Start the program.

```
    $ recorderd --config-file="${HOME}/.config/recorderd/recorderd.conf" start
```

For more information on `recorderd` sub-commands, run the following command:

```
    $ recorderd --config-file="${HOME}/.config/recorderd/recorderd.conf" help
```