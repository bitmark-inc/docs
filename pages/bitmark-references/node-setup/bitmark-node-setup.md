---
title: Bitmark Node Installation
keywords: node, node setup
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/node-setup/tutorial-for-node-setup
folder: bitmark-references/node-setup
---

#  Bitmark Node Installation

A full-node of bitmarkd consists of a `bitmarkd`, a `recorderd`, a payment system, a `litecoind`, and a `bitcoind`. The `bitmarkd` service  verifies and records transactions on the Bitmark blockchain while the `recorderd` service computes the Bitmark proof-of-work algorithm that allows nodes to compete to win blocks on the Bitmark blockchain. 

This tutorial explains how to set up the `bitmarkd` and/or the `recorderd` services by hand.

## Prerequisites

+ You must have and know your **public IP** address.
+ You must have **a Bitcoin and a Litecoin address** for receiving mining rewards.
+ Your environment must be open for incoming connections through port 2136.
+ Hardware minimum requirements:
    - memory >= 2G
    - free disk space >= 20G
    - broadband Internet connection with upload speeds of at least 400 kilobits (50 kilobytes) per second

## Installing a Bitmark Node and Generating Required Keys and Certificates

Installing the required packages requires specific commands on Debian, FreeBSD, macOS, and Ubuntu.

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

### MacOSX

You need [Brew](https://brew.sh/) installed and configured.

```shell
$ brew tap bitmark-inc/bitmark
$ brew install bitmarkd
```

### Building From Source

[See detailed instructions here.](https://github.com/bitmark-inc/bitmarkd)

## Setting up and running `bitmarkd`

The installation includes a sample configuration which has some embedded instructions for quick setup, and only a few items near the beginning of the file need to be changed for basic use. The sample configuration could be found at:

| OS      | Sample configuration file path            |
|---------|-------------------------------------------|
| FreeBSD | `/usr/local/etc/bitmarkd.sample`          |
| Ubuntu  | `/etc/bitmarkd.sample`                    |
| MacOSX  | `/usr/local/etc/bitmarkd/bitmarkd.sample` |

Create the configuration directory and copy the sample configuration:

```shell
$ cp ${SAMPLE_CONFIGURATION_PATH}  ~/.bitmarkd.conf
```

Edit the `bitmarkd.conf` to set up appropriate chain, cryptocurrencies addresses, IP addresses, and ports.

Finally, start the program.

```
$ bitmarkd --config-file="${CONFIG_FILE_PATH}" start
```

For more information on `bitmarkd` sub-commands, run the following command:
```
$ bitmarkd --config-file="${CONFIG_FILE_PATH}" help
```

## Setting up and running `recorderd`

`recorderd` is the mining program for the Bitmark Property System, which can optionally be run to support the Bitmark blockchain (and to earn bitmarks on blocks). 

Setting up `recorderd` is similar to setting up `bitmarkd`.

First, setup and edit your configuration file. For mining using the local `bitmarkd`, the sample configuration should work without changes.

| OS      | CONFIG_FILE_PATH                |
|---------|---------------------------------|
| FreeBSD | `/usr/local/etc/recorderd.conf` |
| Ubuntu  | `/etc/recorderd.conf`           |
| MacOSX  | `/usr/local/etc/recorderd/recorderd.conf` |

Start the program.

```
$ recorderd --config-file="${CONFIG_FILE_PATH}" start
```

For more information on `recorderd` sub-commands, run the following command:

```
$ recorderd --config-file="${CONFIG_FILE_PATH}" help
```
