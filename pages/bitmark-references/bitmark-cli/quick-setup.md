---
title: Bitmark-CLI Quick Setup
keywords: cli, bitmark-cli, command line interface, quick setup
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-cli/bitmark-cli-quick-setup
folder: bitmark-references/bitmark-cli
---

# Quick Setup

The `bitmark-cli` program can be used on both the testing and Bitmark blockchains, with separate configuration files created for each blockchain to avoid confusion.

## Creating an Identity

The first step in setting up `bitmark-cli` is to create an initial identity, which will be used by default for any actions that require a signature:

~~~
bitmarkcli -i IDENTITY -n NETWORK setup -d 'DESCRIPTION OF IDENTITY' -c HOST:2130
~~~

## Configuring the CLI

You can then create the initial configuration file.

For the testing blocking:

~~~
bitmarkcli -i fred -n testing setup -n -d 'Testing account for Fred' -c node-a1.test.bitmark.com:2130
~~~

For the Bitmark blockchain:

~~~
bitmarkcli -i fred -n bitmark setup -n -d 'Live account for Fred' -c node-a1.live.bitmark.com:2130
~~~


The configuration file will have a path such as `${XDG_CONFIG_HOME}/bitmark-cli/testing-cli.json` and will look like this:


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

Once this initial setup is complete, all functions of the command-line interface program (CLI) will be available to use.

Security:
* During setup you will be asked for a password. Make sure it is secure, as it is the only thing that prevents the secret data
  in the file from being decrypted.
* It is also recommended that the `seed` command be used to display
  the recovery phrase for your data; print this and carefully store it to allow recovery
  or to add this account to another computer.

## Adding Extra Connections

If you want to use  the connection feature to be able to send to
different nodes then the above file will have to be edited to add
them. The JSON configuration can be edited in any text editor, but be
careful to keep the formatting correct; JSON is not tolerant of
missing or extraneous commas.

**Testing Example:**

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

Now the bitmark-cli can use the global `-c N` option where N is in the range 0…3 for the four different connections.
This is useful for scripts, which can now spread their load across multiple nodes

**Bitmark Blockchain Example:**

For the live bitmark block chain the servers are:

~~~
  "connections": [
    "node-a1.live.bitmark.com:2130",
    "node-a2.live.bitmark.com:2130",
    "node-a3.live.bitmark.com:2130",
    "node-a4.live.bitmark.com:2130"
  ],
~~~
