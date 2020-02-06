---
title: Quick Setup
keywords: cli, bitmark-cli, command line interface, quick setup
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-cli/bitmark-cli-quick-setup
folder: bitmark-references/bitmark-cli
---

# Quick Setup

The bitmark-cli program is able to create an initial configuration
when none exists.  It uses separate configuration files for testing
and bitmark block chains so that there will not be any confusion.  The
first action is to create an initial identity that will be used by
default for any actions that require a signature.

The initial setup command:

~~~
bitmarkcli -i IDENTITY -n NETWORK setup -d 'DESCRIPTION OF IDENTITY' -c HOST:2130
~~~

For the testing network:

~~~
bitmarkcli -i fred -n testing setup -n -d 'Testing account for Fred' -c node-a1.test.bitmark.com:2130
~~~


For the bitmark network:

~~~
bitmarkcli -i fred -n bitmark setup -n -d 'Live account for Fred' -c node-a1.live.bitmark.com:2130
~~~


The configuration file will look like:
path of file: `${XDG_CONFIG_HOME}/bitmark-cli/testing-cli.json`


~~~
{
  "default_identity": "fred",
  "testnet": true,
  "connections": [
    "node-a1.test.bitmark.com:2130"
  ],
  "identities": {
    "fred": {
      "description": "Testing account for Fred",
      "account": "XXX...XXX",
      "data": "XXX...XXX",
      "salt": "XXX...XXX"
    }
  }
}
~~~

Once this initial setup is complete all functions of the CLI are now available to use.

Security:
* During setup you will be asked for a password, make sure this is a
  secure one as this is the only thing that prevents the secret data
  in the file from being decrypted.
* It is also recommended that the `seed` command is used to display
  the recovery phrase; print this and keep carefully to allow recovery
  or to add this account to another computer.


# Adding extra connections

If you want to make use of the connection feture to be able to send to
different nodes then the above file will have to be edited to add
them. The JSON configuration can be edited in any text editor, but be
careful to keep the formatting correct; JSON is not tolerant of
missing or extraneous commas.


Example:

~~~
{
  "default_identity": "fred",
  "testnet": true,
  "connections": [
    "node-a1.test.bitmark.com:2130",
    "node-a2.test.bitmark.com:2130",
    "node-a3.test.bitmark.com:2130",
    "node-a4.test.bitmark.com:2130"
  ],
  "identities": {
    "fred": {
      "description": "Testing account for Fred",
      "account": "XXX...XXX",
      "data": "XXX...XXX",
      "salt": "XXX...XXX"
    }
  }
}
~~~

Now the bitmark-cli can use the global `-c N` option where N is in the range 0…3.
this is useful for scripts to be able to spred the load across multiple nodes

For the live bitmark block chain the servers are:

~~~
  "connections": [
    "node-a1.live.bitmark.com:2130",
    "node-a2.live.bitmark.com:2130",
    "node-a3.live.bitmark.com:2130",
    "node-a4.live.bitmark.com:2130"
  ],
~~~
