#  Tutorial For Node Setup 

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


## Set Up For Running A Node


### Compilation Commands For All Operating Systems
To compile use use the git command to clone the repository and the go command to compile all commands. The process requires that the Go installation be 1.12 or later as the build process uses Go Modules.

```
git clone https://github.com/bitmark-inc/bitmarkd
cd bitmarkd
go install -v ./...
```

### Setup Directory

Ensure that the ${HOME}/go/bin directory is on the path before continuing. The commands below assume that a checked out and compiled version of the system exists in the ${HOME}/bitmarkd directory.

### Setup and Run bitmarkd

Create the configuration directory, copy sample configuration, edit it to set up IP addresses, ports and local bitcoin testnet connection. The sample configuration has some embedded instructions for quick setup and only a few items near the beginning of the file need to be set for basic use.

```
mkdir -p ~/.config/bitmarkd
cp ~/bitmarkd/command/bitmarkd/bitmarkd.conf.sample  ~/.config/bitmarkd/bitmarkd.conf
${EDITOR} ~/.config/bitmarkd/bitmarkd.conf
```
To see the bitmarkd sub-commands:

```
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" help
```

Generate key files and certificates.

```
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" gen-peer-identity "${HOME}/.config/bitmarkd/
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" gen-rpc-cert "${HOME}/.config/bitmarkd/
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" gen-proof-identity "${HOME}/.config/bitmarkd/
```
Start the program.

```
bitmarkd --config-file="${HOME}/.config/bitmarkd/bitmarkd.conf" start
```

### Setup and Run Recorderd (the mining program)

This is similar to the bitmarkd steps above. For mining on the local bitmarkd the sample configuration should work without changes.

```
mkdir -p ~/.config/recorderd
cp ~/bitmarkd/command/recorderd/recorderd.conf.sample  ~/.config/recorderd/recorderd.conf
${EDITOR} ~/.config/recorderd/recorderd.conf
```

To see the recorderd sub-commands:

```
recorderd --config-file="${HOME}/.config/recorderd/recorderd.conf" help
```

Generate key files and certificates.

```
recorderd --config-file="${HOME}/.config/recorderd/recorderd.conf" generate-identity "${HOME}/.config/recorderd/
```

Start the program.

```
recorderd --config-file="${HOME}/.config/recorderd/recorderd.conf" start
```

###### tags: `bitmarkd` `documentation` `tutorial'` `bitmark`