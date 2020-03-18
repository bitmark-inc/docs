---
title: Share rights
keywords: share rights
last_updated: 
sidebar: mydoc_sidebar
permalink: /register-and-control-data/share-rights
folder: register-and-control-data
---

# Share rights

In some cases, the ownership of a property is shared between different parties or people. To support these situations, the Bitmark Property System provides a feature called **[Bitmark shares](shares/bitmark-shares.md)**.

Any owner of a Bitmark Certificate is able to:

* [Create Bitmark shares](#creating-bitmark-shares) from that Bitmark Certificate.
* [Grant Bitmark shares](#granting-bitmark-shares-to-another-account) to another account.
* [Swap Bitmark shares](#swapping-bitmark-shares) with other accounts.

Currently, only the Bitmark CLI supports working with bitmark shares. Transactions related to Bitmark shares require a transaction fee. On the bitmark network, the fee can be paid with BTC or LTC

* Real BTC and/or LTC are used to pay for transaction fee on the Bitmark main chain
* Testnet BTC and/or LTC are used to pay for transaction fee on the Bitmark testing chain

### About Bitmark shares records

Three records related to Bitmark shares are stored on the Bitmark blockchain.

* *Balance Record* - created by a bitmark owner to permanently set the total number of a particular share for a Bitmark Certificate.
* *Grant Record* - created by an owner to grant an amount of his share balance to another owner.
* *Swap Record* - created by two owners to simultaneously swap their shares of different Bitmark Certificates.


## Prerequisites

The `bitmark-wallet` software is required for paying for transactions. Please refer to the [CLI Payment](cli/cli-payment.md) document for instructions on installing it.

## Create Bitmark shares

Any Bitmark owner can divide a Bitmark Certificate into a number of shares by creating the shares and paying the associated fees. Additional commands can be used to verify the transaction.

* The initial number of shares is not changeable once a Bitmark Certificate is divided.
* Once the Bitmark Certificate is converted into shares, it can no longer be transferred any more, though the shares can be granted or swapped. The provenance of the bitmark is concluded.
* All of the created shares are allocated to the owner.

{% codetabs %}
{% codetab Command %}
```shell
# Create a Bitmark shares from a bitmark
$ bitmark-cli -n <network> -i <identity> share -t <txid> -q <quantity>

# Run the bitcoind
$ bitcoind -datadir=<bitcoind config dir>
# OR run the litecoind
$ litecoind -datadir=<litecoind config dir>

#Pay for a share creation by BTC
$ bitmark-wallet --conf <Bitmark Wallet config file> btc --<btc network> sendmany --hex-data '<payId>' '<btc address>,<btc amount in satoshi>'
#OR Pay for a share creation by LTC
$ bitmark-wallet --conf <Bitmark-Wallet config file> ltc --<ltc network> sendmany --hex-data '<payId>' '<ltc address>,<ltc amount in photon>'

# Check a share creation transaction status
$ bitmark-cli -n <network> status -t <txid>

# Verify the number of shares
$ bitmark-cli -n <network> balance -o <owner identity>

```
{% endcodetab %}
{% codetab Example %}
```shell
# Create a Bitmark shares from a bitmark
$ bitmark-cli -n testing -i first share -t b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23 -q 1000

# Run the bitcoind
$ bitcoind -datadir=${HOME}/.config/bitcoin/

#Pay for the share creation by BTC
$ bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf btc --testnet sendmany --hex-data 'b5000d490f2194307db84d86c6bed022cadf1c6f5cef7e5eb73ac871454aa5bf8ae3219cfe73fd6c53770f7ecba7b413' '2MvrbNpfr6zWG2Mm2hnCh735hPwjoist3Ep,20000'

# Check the share creation transaction status
$ bitmark-cli -n testing status -t 6f8cccbb8db2e2304227abb91cf0cbceaed79376b9d7b0181d28fa20f04fe2a3

# Verify the number of shares
$ bitmark-cli -n testing balance -o first

```
{% endcodetab %}
{% codetab Output %}
```json
// Create a Bitmark shares from a bitmark
/*=====================================*/
{
  "txId": "6f8cccbb8db2e2304227abb91cf0cbceaed79376b9d7b0181d28fa20f04fe2a3",
  "shareId": "b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23",
  "payId": "b5000d490f2194307db84d86c6bed022cadf1c6f5cef7e5eb73ac871454aa5bf8ae3219cfe73fd6c53770f7ecba7b413",
  "payments": {
    "BTC": [
      {
        "currency": "BTC",
        "address": "2MvrbNpfr6zWG2Mm2hnCh735hPwjoist3Ep",
        "amount": "20000"
      }
    ],
    "LTC": [
      {
        "currency": "LTC",
        "address": "mv7pHLntNcEe8YQqCJGWTyL6aa8hjMRL9B",
        "amount": "200000"
      }
    ]
  }
}

// Pay for a share creation
/*=======================*/
{
  "txId": "fc208c0...12c3d82",
  "rawTx": "0100000001e45...7b41300000000"
}

// Check a share creation transaction status
/*========================================*/
//Right after the payment
{
  "status": "Verified"
}
//Check again after some minutes
{
  "status": "Confirmed"
}

// Verify the number of shares
/*==========================*/
{
  "balances": [
    {
      "shareId": "b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23",
      "confirmed": 1000,
      "spend": 0,
      "available": 1000
    }
  ]
}

```
{% endcodetab %}
{% endcodetabs %}


## Granting Bitmark shares to another account

Any user with a non-zero share balance can grant shares from that balance to another account. This is a three-part process: initializing the granting of shares; countersigning the grant; and paying for the transaction. Afterward, the transaction can be verified.

The share grant transaction requires two signatures. Therefore, after the current share owner initializes the grant, the new owner needs to sign to accept the shares.

{% codetabs %}
{% codetab Command %}
```shell
# Initialize a share grant
$ bitmark-cli -n <network> -i <current owner identity> grant -r <recipient> -s <shareid> -q <quantity>

# Countersign a share grant
$ bitmark-cli -n <network> -i <recipient identity> countersign -t <hex-data>

# Pay for a share grant by BTC
$ bitmark-wallet --conf <Bitmark Wallet config file> btc --<btc network> sendmany --hex-data '<payId>' '<btc address>,<btc amount in satoshi>'
# OR Pay for a share grant by LTC
$ bitmark-wallet --conf <Bitmark-Wallet config file> ltc --<ltc network> sendmany --hex-data '<payId>' '<ltc address>,<ltc amount in photon>'

# Check a share grant transaction status
$ bitmark-cli -n <network> status -t <txid>

# Verify the share balance change of an account
$ bitmark-cli -n <network> balance -o <owner identity>
```
{% endcodetab %}
{% codetab Example %}
```shell
# Initialize a share grant
$ bitmark-cli -n testing -i first grant -r second -s 6f8cccbb8db2e2304227abb91cf0cbceaed79376b9d7b0181d28fa20f04fe2a3 -q 100

# Countersign the share grant
$ bitmark-cli -n testing -i second countersign -t 0920b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23642113cbcf0da30e9e1b5acd9cd33f76ef6d93fcec6c81c0a7f3d3fb54d29d3ba8a8472113bff8a5e558bdefeaa3fe482dbc9d929e4e6c60ca585e9191e4636bafb9d9144f5f20140b7498423c8b26a159846474cfe84d1c2f9c16ca66192ebf3cc7b3225bbd47dfe666f8bfbf319352d13b7b2686971ded2d42c718e2f4a1b0019f6aa8a8b5d7c0e

# Pay for the share grant by LTC
$ bitmark-wallet --conf ~/.config/bitmark-wallet/test/test-bitmark-wallet.conf ltc --testnet sendmany --hex-data '3728cb6a24f92801ac5fb0f29db58803339fecbe77dafad5cda9b1be9755a9a7d16b67428f7c3cebaccd10a20f6d8462' 'mv7pHLntNcEe8YQqCJGWTyL6aa8hjMRL9B,100000' 'mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds,100000'

# Check the share grant transaction status
$ bitmark-cli -n testing status -t fc88099d56c6f33bd90eb35937aa5d6e875c00017e7a78046ab3e5279b337e57

# Verify the balance change on the sender side
$ bitmark-cli -n testing balance -o first

# Verify the balance change on the recipient side
$ bitmark-cli -n testing balance -o second
```
{% endcodetab %}
{% codetab Output %}
```json
// Initialize a share grant
/*=======================*/
{
  "identity": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
  "grant": "0920b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23642113cbcf0da30e9e1b5acd9cd33f76ef6d93fcec6c81c0a7f3d3fb54d29d3ba8a8472113bf8f8a5e558bdefeaa3fe482dbc9d929e4e6c60ca585e9191e4636bafb9d9144f5f20140b7498423c8b26a159846474cfe84d1c2f9c16ca66192ebf3cc7b3225bbd47dfe666f8bfbf319352d13b7b2686971ded2d42c718e2f4a1b0019f6aa8a8b5d7c0e"
}

// Countersign the share grant
/*==========================*/
{
  "grantId": "fc88099d56c6f33bd90eb35937aa5d6e875c00017e7a78046ab3e5279b337e57",
  "payId": "3728cb6a24f92801ac5fb0f29db58803339fecbe77dafad5cda9b1be9755a9a7d16b67428f7c3cebaccd10a20f6d8462",
  "payments": {
    "BTC": [
      {
        "currency": "BTC",
        "address": "2MvrbNpfr6zWG2Mm2hnCh735hPwjoist3Ep",
        "amount": "10000"
      },
      {
        "currency": "BTC",
        "address": "mr8DEygRvQwKfP4sVZuHVozqvzW89e193j",
        "amount": "10000"
      }
    ],
    "LTC": [
      {
        "currency": "LTC",
        "address": "mv7pHLntNcEe8YQqCJGWTyL6aa8hjMRL9B",
        "amount": "100000"
      },
      {
        "currency": "LTC",
        "address": "mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds",
        "amount": "100000"
      }
    ]
  }
}

// Pay for the share grant by LTC
/*=============================*/
{
  "txId": "f61c41e7261508f9f65fa73c5af93a86e02ba82361e8f01afde9245d0bbe82dc",
  "rawTx": "0100000001b6e8...846200000000"
}

// Check the share grant transaction status
/*=======================================*/
{
  "status": "Verified"
}
//Check again after some minutes
{
  "status": "Confirmed"
}

// Verify the balance change on the sender side
/*===========================================*/
{
  "balances": [
    {
      "shareId": "b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23",
      "confirmed": 900,
      "spend": 0,
      "available": 900
    }
  ]
}

// Verify the balance change on the recipient side
/*==============================================*/
{
  "balances": [
    {
      "shareId": "0f366f3ee477a75c6304746f45296d804c08be06ad0941313371a17fe07d778f",
      "confirmed": 2000,
      "spend": 0,
      "available": 2000
    },
    {
      "shareId": "b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23",
      "confirmed": 100,
      "spend": 0,
      "available": 100
    }
  ]
}
```
{% endcodetab %}
{% endcodetabs %}


## Swapping Bitmark shares

Owners of shares of two different bitmark Bitmark Certificates can simultaneously swap their shares. 

Similar to share granting, share swapping is a three-part process: one owner (the sender) initializes the swapping; the other owner (the recipient) countersigns to accept the swap and to execute the transaction; and then someone makes a payment. Afterward, the transaction can be verified.

{% codetabs %}
{% codetab Command %}
```shell
# Initialize a share swap
$ bitmark-cli -n <network> -i <sender identity> swap -r <recipient> -s <shareId1> -q <quantity1> -S <shareId2> -Q <quantity2> -b <block_number>

# Countersign a share swap
$ bitmark-cli -n <network> -i <recipient identity> countersign -t <hex-data>

# Pay for a share swap by BTC
$ bitmark-wallet --conf <Bitmark Wallet config file> btc --<btc network> sendmany --hex-data '<payId>' '<btc address>,<btc amount in satoshi>'
# OR Pay for a share swap by LTC
$ bitmark-wallet --conf <Bitmark-Wallet config file> ltc --<ltc network> sendmany --hex-data '<payId>' '<ltc address>,<ltc amount in photon>'

# Check a share swap transaction status
$ bitmark-cli -n <network> status -t <txid>

# Verify the share balance change of an account
$ bitmark-cli -n <network> balance -o <owner identity>
```
{% endcodetab %}
{% codetab Example %}
```shell
# Initialize a share swap
$ bitmark-cli -n testing -i first swap -r second -s b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23 -q 150 -S 0f366f3ee477a75c6304746f45296d804c08be06ad0941313371a17fe07d778f -Q 250 -b 31099

# Countersign the share swap
bitmark-cli -n testing -i second countersign -t 0a20b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba2396012113cbcf0da30e9e1b5acd9cd33f76ef6d93fcec6c81c0a7f3d3fb54d29d3ba8a847200f366f3ee477a75c6304746f45296d804c08be06ad0941313371a17fe07d778ffa012113bf8f8a5e558bdefeaa3fe482dbc9d929e4e6c60ca585e9191e4636bafb9d9144fbf2014078889ed3239b68dc9d78a13c83bd7cd92a8f78e97842d554abb57dea7cc268166228253b094e86273b85010a582e59ee8d5b07d9d9c795c5fe84695b87dcf704

# Pay for the share swap by LTC
$ bitmark-wallet --conf ~/.config/bitmark-wallet/test/test-bitmark-wallet.conf ltc --testnet sendmany --hex-data 'c369cc6d69b34d009cdfe7ff1b3f93dc7c38d90cf13cafe45731793bf6cf37e04f8694cde7a2171e12b6623b5fa64e28' 'mv7pHLntNcEe8YQqCJGWTyL6aa8hjMRL9B,100000' 'mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds,100000'

# Check the share swap transaction status
$ bitmark-cli -n testing status -t c54ac8727a02ad006c4c670f27e9b51e45ef255bb703ff13fa03206b8e60da7e

# Verify the balance change on the sender side
$ bitmark-cli -n testing balance -o first

# Verify the balance change on the recipient side
$ bitmark-cli -n testing balance -o second
```
{% endcodetab %}
{% codetab Output %}
```json
// Initialize a share swap
/*======================*/
{
  "identity": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
  "swap": "0a20b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba2396012113cbcf0da30e9e1b5acd9cd33f76ef6d93fcec6c81c0a7f3d3fb54d29d3ba8a847200f366f3ee477a75c6304746f45296d804c08be06ad0941313371a17fe07d778ffa012113bf8f8a5e558bdefeaa3fe482dbc9d929e4e6c60ca585e9191e4636bafb9d9144fbf2014078889ed3239b68dc9d78a13c83bd7cd92a8f78e97842d554abb57dea7cc268166228253b094e86273b85010a582e59ee8d5b07d9d9c795c5fe84695b87dcf704"
}

// Countersign the share swap
/*==========================*/
{
  "swapId": "c54ac8727a02ad006c4c670f27e9b51e45ef255bb703ff13fa03206b8e60da7e",
  "payId": "c369cc6d69b34d009cdfe7ff1b3f93dc7c38d90cf13cafe45731793bf6cf37e04f8694cde7a2171e12b6623b5fa64e28",
  "payments": {
    "BTC": [
      {
        "currency": "BTC",
        "address": "2MvrbNpfr6zWG2Mm2hnCh735hPwjoist3Ep",
        "amount": "10000"
      },
      {
        "currency": "BTC",
        "address": "mr8DEygRvQwKfP4sVZuHVozqvzW89e193j",
        "amount": "10000"
      }
    ],
    "LTC": [
      {
        "currency": "LTC",
        "address": "mv7pHLntNcEe8YQqCJGWTyL6aa8hjMRL9B",
        "amount": "100000"
      },
      {
        "currency": "LTC",
        "address": "mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds",
        "amount": "100000"
      }
    ]
  }
}

// Pay for the share swap by BTC
/*============================*/
{
  "txId": "2d636380c17c7792b6e659efe7c978dcbab44b9161fd8ad65b6c084a05376ab7",
  "rawTx": "0100000001dc...4e2800000000"
}

// Check the share swap transaction status
/*======================================*/
// Right after the payment
{
  "status": "Verified"
}
// Check again after some minutes
{
  "status": "Confirmed"
}

// Verify the balance change on the sender side
/*===========================================*/
{
  "balances": [
    {
      "shareId": "0f366f3ee477a75c6304746f45296d804c08be06ad0941313371a17fe07d778f",
      "confirmed": 250,
      "spend": 0,
      "available": 250
    },
    {
      "shareId": "b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23",
      "confirmed": 750,
      "spend": 0,
      "available": 750
    }
  ]
}

// Verify the balance change on the recipient side
/*==============================================*/
{
  "balances": [
    {
      "shareId": "0f366f3ee477a75c6304746f45296d804c08be06ad0941313371a17fe07d778f",
      "confirmed": 1750,
      "spend": 0,
      "available": 1750
    },
    {
      "shareId": "b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23",
      "confirmed": 250,
      "spend": 0,
      "available": 250
    }
  ]
}
```
{% endcodetab %}
{% endcodetabs %}

For the details of CLI commands and their parametters, please refer to the [CLI command reference](cli/cli-command-reference.md).


## Explore the transactions using the Registry website

Users can explore all of the transactions on the Bitmark blockchain using the Bitmark Registry website:

* [Explore transactions on the Bitmark blockchain](https://registry.bitmark.com)

* [Explore transactions on the Bitmark testnet blockchain](https://registry.test.bitmark.com)


## References

CLI
  * [CLI command reference](cli/cli-command-reference.md)
  * [CLI quick setup](cli/cli-quick-setup.md)


SDK
  * [SDK Getting Started](sdk/getting-started.md)
  * [SDK Account](sdk/account.md)
  * [SDK Action](sdk/action.md)
  * [SDK Query](sdk/query.md)
  * [SDK Migration](sdk/migration.md)
  * [SDK Store Seed](sdk/store-seed.md)
  * [SDK Web Socket](sdk/websocket.md)