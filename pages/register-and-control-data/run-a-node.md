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

+ You must have and know your **public IP** address.
+ You must have **a Bitcoin and a Litecoin address** for receiving mining rewards.
+ Your environment must be open for incoming connections through port 2136.
+ Hardware minimum requirements:
    - memory >= 2 GB
    - free disk space >= 20 GB
    - broadband Internet connection with upload speeds of at least 400 kilobits (50 kilobytes) per second

## Installing a Bitmark Node and Generating Required Keys and Certificates

Bitmark nodes can be installed on a variety of different operating systems, with pre-built packages available for FreeBSD, Ubuntu, and macOS.

If some special functionality is required, or there are no available packages yet for your OS, a Bitmark node can also be compiled from source files. For more information, see [Building From Source](#building-from-source).

### FreeBSD

```shell
$ pkg install bitmark
$ service bitmarkd keygen
$ service recorderd keygen
```

### Ubuntu

```shell
$ add-apt-repository -y ppa:bitmark/bitmarkd
$ apt update
$ apt install bitmarkd
```

### macOS

You need to install Brew:

```shell
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Visit the [Brew](https://brew.sh/) site for more information on the installation and configuration options.

```shell
$ brew tap bitmark-inc/bitmark
$ brew install bitmarkd
```

### Building From Source

[See detailed instructions here.](https://github.com/bitmark-inc/bitmarkd#operating-system-specific-setup-commands)

## Setting up and running bitmarkd

The installation includes a sample configuration which has some embedded instructions for quick setup, and only a few items near the beginning of the file need to be changed for basic use. The sample configuration could be found at:

| OS      | Sample configuration file path            |
|---------|-------------------------------------------|
| FreeBSD | `/usr/local/etc/bitmarkd.sample`          |
| Ubuntu  | `/etc/bitmarkd.sample`                    |
| macOS   | `/usr/local/etc/bitmarkd/bitmarkd.sample` |

Copy the sample configuration.

```shell
$ cp ${SAMPLE_CONFIGURATION_PATH}  ~/.bitmarkd.conf
```

Edit the `bitmarkd.conf` to set up appropriate chain, cryptocurrencies addresses, IP addresses, and ports.

```shell	
$ ${EDITOR} ~/.bitmarkd.conf	
```

Finally, start the program.

```shell
$ bitmarkd --config-file=~/.bitmarkd.conf start
```

For more information on `bitmarkd` sub-commands, run the following command:

```shell
$ bitmarkd --config-file=~/.bitmarkd.conf help
```

## Setting up and running recorderd

`recorderd` is the mining program for the Bitmark Property System, which can optionally be run to support the Bitmark blockchain (and to earn bitmarks on blocks). 

Setting up `recorderd` is similar to setting up `bitmarkd`.

First, setup and edit your configuration file. For mining using the local `bitmarkd`, the sample configuration should work without changes.

| OS      | Sample configuration file path            |
|---------|-------------------------------------------|
| FreeBSD | `/usr/local/etc/recorderd.conf`           |
| Ubuntu  | `/etc/recorderd.conf`                     |
| macOS   | `/usr/local/etc/recorderd/recorderd.conf` |

Copy the sample configuration.

```shell
$ cp ${SAMPLE_CONFIGURATION_PATH}  ~/.recorderd.conf
```

Start the program.

```
$ recorderd --config-file=~/.recorderd.conf start
```

For more information on `recorderd` sub-commands, run the following command:

```shell
$ recorderd --config-file=~/.recorderd.conf help
```