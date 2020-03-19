---
title: Installation
keywords: installation
last_updated: 
sidebar: mydoc_sidebar
permalink: /essentials/installation
folder: essentials
---

# Installation

Users can interact with the Bitmark System using 

* The Bitmark SDK
* The Bitmark CLI.

## SDK Installation and Configuration
The Bitmark SDK enables data registration, rights transfer, and registry querying in the Bitmark property system. The SDK's simplified interface allows developers to easily build on the core Bitmark infrastructure by reading from and writing to the Bitmark blockchain.

### Install SDK Packages

The SDK can be installed for JavaScript, Swift, Java, or Go.

{% codetabs %}
{% codetab JS %}
```javascript
$ npm install bitmark-sdk-js
```
{% endcodetab %}
{% codetab Swift %}
```swift
pod 'BitmarkSDK'
```
{% endcodetab %}
{% codetab Java %}
```java
// From your build.gradle
repositories {
    jcenter()
    maven { url 'https://oss.sonatype.org/content/repositories/snapshots/' } // For snapshot version
}

dependencies {
    implementation 'com.bitmark.sdk:java-sdk:2.1.0' // Java SDK
    // Or
    implementation 'com.bitmark.sdk:android-sdk:2.1.0' // Android SDK
}
```
{% endcodetab %}
{% codetab Go %}
```go
$ go get github.com/bitmark-inc/bitmark-sdk-go
```
{% endcodetab %}
{% endcodetabs %}

### Acquiring an API token

An API token is required to authenticate requests to the Bitmark API.

Please contact [Bitmark support](mailto:support@bitmark.com) to create a developer account and get an API token.

### Configuring the SDK

Before working with the Bitmark blockchain, configure the SDK for your API token and the Bitmark network that you'll be using.

{% codetabs %}
{% codetab JS %}
```javascript
const sdk = require('bitmark-sdk-js');

const config = {
  apiToken: "api-token",
  network: "testnet"
};

sdk.init(config);
```
{% endcodetab %}
{% codetab Swift %}
```swift
import BitmarkSDK

BitmarkSDK.initialize(config: SDKConfig(apiToken: "api-token",
                                        network: .testnet,
                                        urlSession: URLSession.shared))
```
{% endcodetab %}
{% codetab Java %}
```java
final GlobalConfiguration.Builder builder = GlobalConfiguration.builder().withApiToken("api-token").withNetwork(Network.LIVE_NET);
BitmarkSDK.init(builder);
```
{% endcodetab %}
{% codetab Go %}
```go
import sdk "github.com/bitmark/bitmark-inc/bitmark-sdk-go"

func main() {
	config := &sdk.Config{
		APIToken: "YOUR API TOKEN",
		Network:  sdk.Testnet,
		HTTPClient: &http.Client{
			Timeout: 10 * time.Second,
		},
	}
	sdk.Init(config)
}
```
{% endcodetab %}
{% endcodetabs %}

## CLI Installation and Setup

The Bitmark CLI is a command line interface which submits transactions to its connected Bitmark Node via RPC. CLI users are able to register data, transfer rights, share rights as well as query the registry by submitting corresponding transactions directly to the connected Node.

### Install the CLI

As the CLI needs to connect with a Node to communicate with the Bitmark Blockchain, the CLI installation is included in the Node installation. 

Refer [Run a node](run-a-node.md) section for the instructions.

### Install the Bitmark wallet for payment

In the Bitmark Property System, only the first bitmark issuance of a registered data is free of charge. All the other transactions require transaction fees. Bitmark transaction fees can be paid in either Bitcoin (BTC) or Litecoin (LTC) cryptocurrencies. Because common wallets do not support attaching the Bitmark blockchain payment identifier to the BTC/LTC transactions, Bitmark provides an app called the Bitmark Wallet to pay for Bitmark transactions that come from the Bitmark CLI.

The main actions required to use the Bitmark wallet are:

* Installing the Bitmark Wallet.
* Syncing the wallet with coins.
* Running the wallet.
* Acquiring testnet coins.

Prerequisites

* Git must be installed.
* Go must be installed.
* Python3 must be installed.
* `bitcoind`/`litecoind` must be installed.

<br>

Install the Bitmark wallet

{% codetabs %}
{% codetab Command %}
```shell
# Clone the Bitmark Wallet
$git clone https://github.com/bitmark-inc/bitmark-wallet.git

# Install the wallet
$cd bitmark-wallet/command/bitmark-wallet
$go install

# Create the Bitmark Wallet's config file
$ mkdir ~/.config/bitmark-wallet
$ touch ~/.config/bitmark-wallet/bitmark-wallet.conf
```
{% endcodetab %}
{% endcodetabs %}


<br>

Connect with bitcoind and litecoind by enabling RPC

{% codetabs %}
{% codetab bitcoin.conf %}
```conf
# RPC server port
rpcport = 18443
rpcbind = 127.0.0.1
rpcbind = [::1]

# RPC configuration
rpcthreads = 20
#rpcssl = 1
rpcallowip = 127.0.0.1
rpcallowip = [::1]

# authentication
rpcauth=cotzntmnxllhcpsshvdzzuue:1c1671f8ffbdd8d845688dc450d2c4e1$ec4723c3a7c29d072c40749017d4d326576c68264595355fac8816d525220f7a
```
{% endcodetab %}
{% codetab litecoin.conf %}
```conf
# RPC server port
rpcport = 19443
rpcbind = 127.0.0.1
rpcbind = [::1]

# RPC configuration
rpcthreads = 20
#rpcssl = 1
rpcallowip = 127.0.0.1
rpcallowip = [::1]

# authentication
rpcauth=wzrhjmlikroaxjnckmgzcrfv:37ff59f93e737d95f3cb15a4c5b81d$ecf9e7d5ceaf79fa136865d950c64b88845582e78f4a7af5e8a1861ad8331f08
```
{% endcodetab %}
{% codetab bitmark-wallet.conf %}
```conf
agent {
  btc{
      type = "daemon"
      node = "localhost:18443"
      user = "cotzntmnxllhcpsshvdzzuue"
      pass = "vN9v95_7qjWiHSMUx2QuriX6fUgjoPyZgJRm-1Og0-g="
  }
  ltc {
    type = "daemon"
    node = "localhost:19443"
    user = "wzrhjmlikroaxjnckmgzcrfv"
    pass = "7iLL9pGM7W4LNQTjDmdYGj6mJ7nBFgYIix5OjRbR-v4="
  }
}
```
{% endcodetab %}
{% endcodetabs %} 

<br>

Run coin servers and Bitmark wallet


{% codetabs %}
{% codetab Command %}
```shell
# Run bitcoind
$ bitcoind -datadir=<bitcoind config dir>

# Run litecoind
$ litecoind -datadir=<litecoind config dir>

# Initialize the Bitmark wallet
$ bitmark-wallet --conf=<conf file> init

# Sync bitcoin
$ bitmark-wallet --conf=<config file> btc sync --<network>

# Sync litecoin
$ bitmark-wallet --conf=<config file> ltc sync --<network>

# Generate BTC address
$ bitmark-wallet --conf=<config file> btc newaddress --<network>

# Generate LTC address
$ bitmark-wallet --conf=<config file> ltc newaddress --<network>
```
{% endcodetab %}
{% codetab Example %}
```shell
# Run bitcoind
$ bitcoind -datadir=${HOME}/.config/bitcoin

# Run litecoind
$ litecoind -datadir=${HOME}/.config/litecoin

# Initialize the Bitmark wallet
$ bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf init

# Sync bitcoin
bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf btc sync --testnet

# Sync litecoin
bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf ltc sync --testnet

# Generate BTC address
$ bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf btc newaddress --testnet

# Generate LTC address
$ bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf ltc newaddress --testnet

```
{% endcodetab %}
{% endcodetabs %} 

<br>

### Getting testnet coins

To fund a mainnet wallet, you'll need to send coins to the BTC or LTC address, but to fund a testnet wallet, you can simply request coins from a faucet.

* Get some testnet ltc at https://faucet.xblau.com/

* Get some testnet btc at https://coinfaucet.eu/en/btc-testnet/
