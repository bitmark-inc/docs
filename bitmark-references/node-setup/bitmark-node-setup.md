#  Tutorial for node setup 

A full-node of bitmarkd consists of a bitmard, a recorderd, a payment system, a litecoind, and a bitcoind services. For a beginner, it is easy and fast to run a bitmark-node-docker which wrapped all components and settings. For a developer or someone who wants to study the main program, the person can run bitmarkd or recorderd service directly. 
Bitmarkd project is the main program of bitmark node. It consists bitmarkd service for verifying and recording transactions in the Bitmark blockchain and recorderd service for computing the Bitmark proof-of-work algorithm that allows nodes to compete to win blocks on the Bitmark blockchain. 

This tutorial explains how to set up the bitmarkd service and/or the recorderd service, by hand.

## Prerequisites

* Install the go language package for the system
* Configure environment variables for go system
* Install the ZMQ4 and Argon2 libraries


### Meeting PreRequisites

#### Installing Packages on FreeBSD

~~~~~
pkg install libzmq4 libargon2
~~~~~

#### Installing Packages on MacOSX

(be sure that homebrew is installed correctly)
~~~~
brew tap bitmark-inc/bitmark
brew install argon2
brew install zeromq43
~~~~

#### Installing Packages on Ubuntu
(tested on version 18.04)

Install following packages
   `sudo apt install libargon2-0-dev uuid-dev libzmq3-dev`


#### Installing Packages on Debian
(tested on version 9)

First we need to add access to testing package's repo as well as to our current version, in this case stable.
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

Now install libargon2 using:
```
apt-get -t testing install libargon2-dev libargon2-1
```

For the other packages, install from stable or testing, both versions work:
```
apt install uuid-dev libzmq3-dev
```

## Installing Bitmarkd

### Compiling Bitmarkd

To manually compile, run these commands:

~~~~~
go get github.com/bitmark-inc/bitmarkd
go install -v github.com/bitmark-inc/bitmarkd/command/bitmarkd
~~~~~

:warning: **Argon2 optimization**

Argon2 can achieve better performance if [AVX instructions](https://en.wikipedia.org/wiki/Advanced_Vector_Extensions) is available. But the potential optimization is not enabled if Argon2 is installed by package managers.

To leverage AVX instructions, extra flag has to be specified during the compilation process.

```shell
make OPTTARGET=native
```

If AVX is not available, make sure Argon2 has no reference to AVX otherwise bitmarkd will crash.

```shell
make OPTTARGET=generic
```

## Installing a Prebuilt Binary

* Flatpak

    Please refer to [wiki](https://github.com/bitmark-inc/bitmarkd/wiki/Instruction-for-Flatpak-Prebuilt)

* Docker

    Please refer to [bitmark-node](https://github.com/bitmark-inc/bitmark-node)


## Setting Up Bitmarkd

Create the configuration directory, copy sample configuration, edit it to
set up IPs, ports and local bitcoin testnet connection.

~~~~~
mkdir -p ~/.config/bitmarkd
cp command/bitmarkd/bitmarkd.conf.sample  ~/.config/bitmarkd/bitmarkd.conf
${EDITOR}   ~/.config/bitmarkd/bitmarkd.conf
~~~~~

To see the bitmarkd sub-commands:

~~~~~
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" help
~~~~~

Generate key files and certificates.

~~~~~
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" gen-peer-identity
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" gen-rpc-cert
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" gen-proof-identity
~~~~~

Start the program.

~~~~~
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" start
~~~~~

Note that a similar process is needed for the recorderd (mining subsystem)

###### tags: `bitmarkd` `documentation` `tutorial'` `bitmark`