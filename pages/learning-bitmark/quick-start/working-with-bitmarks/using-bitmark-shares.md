---
title: Using Bitmark Shares
keywords: bitmark shares
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/working-with-bitmarks/using-bitmark-shares
folder: learning-bitmark/quick-start/working-with-bitmarks
---

# Working with Bitmark shares

In some cases, the ownership of a property is shared between different parties or people. To support these situations, the Bitmark Property System provides a feature called **[Bitmark shares](https://docs.bitmark.com/bitmark-appendix/bitmark-shares)**.

Any owner of a Bitmark Certificate is able to:

* [Create Bitmark shares](#creating-bitmark-shares) from that Bitmark Certificate.
* [Grant Bitmark shares](#granting-bitmark-shares-to-another-account) to another account.
* [Swap Bitmark shares](#swapping-bitmark-shares) with other accounts.


Currently, only the Bitmark CLI supports working with bitmark shares.

> **NOTE:** Transactions related to Bitmark shares require a transaction fee. On the bitmark network, the fee can be paid with BTC or LTC
>
> * Real BTC and/or LTC are used to pay for transaction fee on the Bitmark main chain
> * Testnet BTC and/or LTC are used to pay for transaction fee on the Bitmark testing chain

### About Bitmark shares records

Three records related to Bitmark shares are stored on the Bitmark blockchain.

* *Balance Record* - created by a bitmark owner to permanently set the total number of a particular share for a Bitmark Certificate.
* *Grant Record* - created by an owner to grant an amount of his share balance to another owner.
* *Swap Record* - created by two owners to simultaneously swap their shares of different Bitmark Certificates.

## Prerequisites

The `bitmark-wallet` software is required for paying for transactions. Please refer to the [CLI Payment](cli/cli-payment.md) document for instructions on installing it.

## Creating Bitmark shares

Any Bitmark owner can divide a Bitmark Certificate into a number of shares by creating the shares and paying the associated fees. Additional commands can be used to verify the transaction.

* The initial number of shares is not changeable once a Bitmark Certificate is divided.

* Once the Bitmark Certificate is converted into shares, it can no longer be transferred any more, though the shares can be granted or swapped. The provenance of the bitmark is concluded.

* All of the created shares are allocated to the owner.

* A share creation transaction costs 0.002 LTC or 0.0002 BTC as the transaction fee.

### Creating Bitmark shares from a Bitmark Certificate

To create Bitmark shares using the Bitmark CLI:

  ```shell
    $ bitmark-cli -n <network> -i <identity> \
      share -t <txid> -q <quantity>
  ```

  >The `share` command creates shares for a Bitmark Certificate. 
  >
  > **Global Options:**
  >* `identity` - The identity of the Bitmark Account of the Bitmark Certificate's owner. The Bitmark Account and its identity are stored in the Bitmark CLI config file.
  >
  > **Command Options:**
  >* `txid` - The latest transaction id in the Bitmark's provenance.
  >
  >* `quantity` - The number of shares to be created.
  >
  >**Returns**
  >* `txid` - The transaction id of the share creation.
  >
  >* `shareId` - The share id, which is also the Bitmark id.
  >
  >* The payment information (`payId`, `currency`, `address`, `amount`).


*Example:*

  ```shell
    $ bitmark-cli -n testing -i first \
      share -t \
      b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23 \
      -q 1000
  ```

  ```json
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
  ```

### Paying for a share creation

To do so using the Bitmark CLI:

  ```shell
    #Run the bitcoind
    $ bitcoind -datadir=<bitcoind config dir>

    # OR run the litecoind
    $ litecoind -datadir=<litecoind config dir>

    #Pay by BTC
    $ bitmark-wallet --conf <Bitmark Wallet config file> btc --<btc network> \
      sendmany --hex-data '<payId>' '<btc address>,<btc amount in satoshi>'

    #OR Pay by LTC
    $ bitmark-wallet --conf <Bitmark-Wallet config file> ltc --<ltc network> \
      sendmany --hex-data '<payId>' '<ltc address>,<ltc amount in photon>'

  ```

    >To execute a bitcoin or litecoin transaction on the local environment, the bitcoind or litecoind daemon needs to be running.
    >
    > - `payId` - The payment id for transfer transaction, printed in the results as `payId`
    > - `btc address` or `ltc address` - The address for payment, printed in the results as `address` under `BTC` or `LTC`
    > - `btc amount` or `ltc amount` - The payment amount, printed in the results as `amount` under `BTC` or `LTC`


*Example — Paying with BTC:*

* Run bitcoind

  ```shell
    $ bitcoind -datadir=${HOME}/.config/bitcoin/
  ```

* Pay for the transaction with bitcoin using the Bitmark Wallet

  ```shell
    $ bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf \
      btc --testnet \
      sendmany --hex-data \
      'b5000d490f2194307db84d86c6bed022cadf1c6f5cef7e5eb73ac871454aa5bf8ae3219cfe73fd6c53770f7ecba7b413' \
      '2MvrbNpfr6zWG2Mm2hnCh735hPwjoist3Ep,20000'
  ```
  ```json
    {
      "txId": "fc208c0...12c3d82",
      "rawTx": "0100000001e45...7b41300000000"
    }
  ```

### Verifying a share creation transaction

To verify the status of the share creation using Bitmark CLI:

  ```shell
    $ bitmark-cli -n <network> \
      status -t <txid>
  ```

  >The `status` command queries a transaction's status.
  >
  >**Command Options:**
  >* `txid` - The transaction id, which is printed in the output of the share creation command.
  >
  >**Returns:**
  >* `Pending` - Not paid.
  >
  >* `Verified` - Paid but not confirmed on the blockchain.
  >
  >* `Confirmed` - Confirmed on the blockchain.


*Example:*

  ```shell
    $ bitmark-cli -n testing \
      status -t \
      6f8cccbb8db2e2304227abb91cf0cbceaed79376b9d7b0181d28fa20f04fe2a3
  ```
  ```json
    //Right after the payment
    {
      "status": "Verified"
    }

    //Check again after some minutes
    {
      "status": "Confirmed"
    }
  ```

<br>

### Verifying the share creation results

To verify a user's share balance using Bitmark CLI:

  ```shell
    $ bitmark-cli -n <network> \
      balance -o <owner identity>

  ```

  >The `owned` command lists all the bitmarks and shares that are owned by a user.
  >
  >**Command Options:**
  >* `owner identity` - The identity of the owner whose shares are being listed (in this case, the owner of the Bitmark Certificate that was just converted into shares)


*Example:*

  ```shell
    $ bitmark-cli -n testing \
      balance -o first
  ```
  ```json
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

## Granting Bitmark shares to another account

Any user with a non-zero share balance can grant shares from that balance to another account. This is a three-part process: initializing the granting of shares; countersigning the grant; and paying for the transaction. Afterward, the transaction can be verified.

### Initializing a share grant

To initialize a grant of shares using the Bitmark CLI:

  ```shell
    # The current owner initializes the grant shares transaction
    $ bitmark-cli -n <network> -i <current owner identity> \
      grant -r <receiver> -s <shareid> -q <quantity>
  ```

  >The `grant` command allows a Bitmark shares owner to grant some of his share balance to another account. Only after the new owner signs to accept the shares will the grant transaction be created and submitted to the blockchain.
  >
  >**Global Options:**
  >* `current owner identity` - The identity of the current share owner's Bitmark Account, which is stored in the Bitmark CLI config file.
  >
  >**Command Options:**
  >* `receiver` - The identifier of the new owner of the granted shares. This can be the receiver's Bitmark Account identity, stored by the Bitmark CLI, or the receiver's Bitmark Account Number.
  >
  >* `shareid` - The share id (share id = bitmark id).
  >
  >* `quantity` - The number of granted shares.
  >
  >**Returns:**
  >* `identity` - The Bitmark Account Number of the current share owner.
  >
  >* `grant` - The hex-data that needs to be signed by the new owner.


*Example:*

  ```shell
    $ bitmark-cli -n testing -i first \
      grant -r second \
      -s 6f8cccbb8db2e2304227abb91cf0cbceaed79376b9d7b0181d28fa20f04fe2a3 \
      -q 100
  ```
  ```json
    {
      "identity": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
      "grant": "0920b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23642113cbcf0da30e9e1b5acd9cd33f76ef6d93fcec6c81c0a7f3d3fb54d29d3ba8a8472113bf8f8a5e558bdefeaa3fe482dbc9d929e4e6c60ca585e9191e4636bafb9d9144f5f20140b7498423c8b26a159846474cfe84d1c2f9c16ca66192ebf3cc7b3225bbd47dfe666f8bfbf319352d13b7b2686971ded2d42c718e2f4a1b0019f6aa8a8b5d7c0e"
    }
  ```

### Countersigning a share grant

The share grant transaction requires two signatures. Therefore, after the current share owner initializes the grant, the new owner needs to sign to accept the shares.

To countersign a share grant using the Bitmark CLI:

  ```
    # The receiver signs to accept the shares
    $ bitmark-cli -n <network> -i <receiver identity> \
      countersign -t <hex-data>
  ```

  >The `countersign` command signs hex data. (In this case, it is used by the `receiver` to sign to accept granted shares.)
  >
  >**Global Options:**
  >* `receiver identity` - The identity of the receiving Bitmark Account, which is stored in the Bitmark CLI config file.
  >
  >* `hex-data` - The `grant` data returned by the `grant` command.
  >
  >**NOTE:** The share grant transaction cost a transaction fee of 0.002 LTC (200000 photons) or 0.0002 BTC (20000 satoshis). Only when the fee is paid, can the transaction be confirmed on the blockchain.
  >The payment information is included in the `coutersign` command's returns.


*Example:*

  ```shell
    $ bitmark-cli -n testing -i second \
      countersign -t \
      0920b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23642113cbcf0da30e9e1b5acd9cd33f76ef6d93fcec6c81c0a7f3d3fb54d29d3ba8a8472113bff8a5e558bdefeaa3fe482dbc9d929e4e6c60ca585e9191e4636bafb9d9144f5f20140b7498423c8b26a159846474cfe84d1c2f9c16ca66192ebf3cc7b3225bbd47dfe666f8bfbf319352d13b7b2686971ded2d42c718e2f4a1b0019f6aa8a8b5d7c0e
  ```
  ```json
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
  ```

  >The returned fields:
  >
  >* `grantId` - The transaction id of the share granting.
  >
  >* `payId` - The payId to attach to the payment command.
  >
  >* `payment` - The corresponding amounts and addresses to pay for the transaction in different currencies.

<br>
<br>

### Paying for a share grant

Payment for a share grant works just the same as payment for a transfer or for share creation.

*Example — Paying with LTC:*

  ```shell
    $ bitmark-wallet --conf ~/.config/bitmark-wallet/test/test-bitmark-wallet.conf \
      ltc --testnet \
      sendmany --hex-data \
      '3728cb6a24f92801ac5fb0f29db58803339fecbe77dafad5cda9b1be9755a9a7d16b67428f7c3cebaccd10a20f6d8462' \
      'mv7pHLntNcEe8YQqCJGWTyL6aa8hjMRL9B,100000' \
      'mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds,100000'
  ```
  ```json
    {
      "txId": "f61c41e7261508f9f65fa73c5af93a86e02ba82361e8f01afde9245d0bbe82dc",
      "rawTx": "0100000001b6e8...846200000000"
    }
  ```

### Verifying a share grant

To verify a grant using the Bitmark CLI:

* Check the transaction status

  ```shell
    $ bitmark-cli -n testing \
      status -t \
      fc88099d56c6f33bd90eb35937aa5d6e875c00017e7a78046ab3e5279b337e57
  ```
  ```json
    {
      "status": "Verified"
    }

    //Check again after some minutes
    {
      "status": "Confirmed"
    }
  ```

* Check the sender's balance

  ```shell
    $ bitmark-cli -n testing balance -o first
  ```
  ```json
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
  ```

* Check the receiver's balance

  ```shell
    $ bitmark-cli -n testing balance -o second
  ```
  ```json
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

## Swapping Bitmark shares

Owners of shares of two different bitmark Bitmark Certificates can simultaneously swap their shares. 

Similar to share granting, share swapping is a three-part process: one owner (the sender) initializes the swapping; the other owner (the receiver) countersigns to accept the swap and to execute the transaction; and then someone makes a payment. Afterward, the transaction can be verified.

### Initializing a share swap

To initialize a swap of shares using the Bitmark CLI:

  ```shell
    $ bitmark-cli -n <network> -i <sender identity> \
      swap -r <receiver> -s <shareId1> -q <quantity1> \
      -S <shareId2> \
      -Q <quantity2> \
      -b <block_number>
  ```

  >The `swap` command initializes a share swap request; this request must be signed by the sender. Once the receiver signs to accept the request, the share swap transaction is created and submitted to the blockchain. 
  >
  >**Global Options:**
  >* `sender identity` - The identity of the sender's Bitmark Account, which is stored in the Bitmark CLI config file.
  >
  >**Command Options:**
  >* `receiver` - The receiver's identifier. It could be the receiver's Bitmark Account Number or an identity that is stored in the Bitmark CLI config file.
  >
  >* `shareId1` - The id of the shares that the sender is swapping.
  >
  >* `quantity1` - The number of shares that the sender wants to swap with the receiver.
  >
  >* `shareId2` - The id of the shares that the receiver is swapping.
  >
  >* `quantity2` - The number of shares that the receiver want to swap with the sender.
  >
  >* `block_number` - A time-limit after which the request expires and becomes invalid. Every 30 blocks from the current block adds one hour of expiration. 
  > - [Bitmark Blockchain's current block height](https://registry.bitmark.com)
  > - [Bitmark Testnet Blockchain's current block height](https://registry.test.bitmark.com)
  >
  >**Note:** The `shareId1` and the `shareId2` are different. They are the ids of different shares, which are generated from different Bitmark Certificates. 


*Example:*

  ```shell
    $ bitmark-cli -n testing -i first \
      swap -r second \
      -s b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23 \
      -q 150 \
      -S 0f366f3ee477a75c6304746f45296d804c08be06ad0941313371a17fe07d778f \
      -Q 250 \
      -b 31099
  ```
  ```json
    {
      "identity": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
      "swap": "0a20b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba2396012113cbcf0da30e9e1b5acd9cd33f76ef6d93fcec6c81c0a7f3d3fb54d29d3ba8a847200f366f3ee477a75c6304746f45296d804c08be06ad0941313371a17fe07d778ffa012113bf8f8a5e558bdefeaa3fe482dbc9d929e4e6c60ca585e9191e4636bafb9d9144fbf2014078889ed3239b68dc9d78a13c83bd7cd92a8f78e97842d554abb57dea7cc268166228253b094e86273b85010a582e59ee8d5b07d9d9c795c5fe84695b87dcf704"
    }
  ```

#### Countersigning a share swap

A share-swap transaction requires two signatures. The sender signs when running the `swap` command, after which the receiver must countersign. This process is the same as when countersigning a `grant` transaction.

*Example:*

  ```shell
    $ bitmark-cli -n testing -i second \
      countersign -t \
      0a20b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba2396012113cbcf0da30e9e1b5acd9cd33f76ef6d93fcec6c81c0a7f3d3fb54d29d3ba8a847200f366f3ee477a75c6304746f45296d804c08be06ad0941313371a17fe07d778ffa012113bf8f8a5e558bdefeaa3fe482dbc9d929e4e6c60ca585e9191e4636bafb9d9144fbf2014078889ed3239b68dc9d78a13c83bd7cd92a8f78e97842d554abb57dea7cc268166228253b094e86273b85010a582e59ee8d5b07d9d9c795c5fe84695b87dcf704
  ```
  ```json
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
  ```

### Paying for a share swap

Paying for a share swap transaction works just the same as paying for a transfer, for share creation, or for a share grant.

*Example — Paying with LTC:*

  ```shell
    $ bitmark-wallet --conf ~/.config/bitmark-wallet/test/test-bitmark-wallet.conf \
      ltc --testnet \
      sendmany --hex-data \
      'c369cc6d69b34d009cdfe7ff1b3f93dc7c38d90cf13cafe45731793bf6cf37e04f8694cde7a2171e12b6623b5fa64e28' \
      'mv7pHLntNcEe8YQqCJGWTyL6aa8hjMRL9B,100000' \
      'mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds,100000'
  ```
  ```json
    {
      "txId": "2d636380c17c7792b6e659efe7c978dcbab44b9161fd8ad65b6c084a05376ab7",
      "rawTx": "0100000001dc...4e2800000000"
    }
  ```

### Verifying a share swap

To thoroughly check the results of a share swap using the Bitmark CLI:

* Check the share swap transaction status

  ```shell
    $ bitmark-cli -n testing \
      status -t \
      c54ac8727a02ad006c4c670f27e9b51e45ef255bb703ff13fa03206b8e60da7e
  ```
  ```json
    // Right after the payment
    {
      "status": "Verified"
    }

    // Check again after some minutes
    {
      "status": "Confirmed"
    }
  ```

* Check the balance of the sending user

  ```shell
    $ bitmark-cli -n testing balance -o first
  ```
  ```json
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
  ```

* Check the balance of the receiving user

  ```shell
    $ bitmark-cli -n testing balance -o second
  ```
  ```json
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
