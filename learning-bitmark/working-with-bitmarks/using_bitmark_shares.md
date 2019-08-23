# Bitmark shares

In some cases, the ownership of a property is shared between different parties or people. To support those cases, the Bitmark Property System provides a feature called the **[bitmark shares]()**. 

Any owner of a Bitmark Certificate is able to:

* [Create bitmark shares](#creating-bitmark-shares) from that certificate (or bitmark).

* [Grant bitmark shares](#granting-bitmark-shares-to-another-account) to another account.

* [Swap bitmark shares](#swapping-bitmark-shares) with others.


Currently, only the Bitmark CLI supports performing those transactions of bitmark shares.

> **NOTE:** Transactions related to the bitmark share require a transaction fee. On the bitmark network, the fee can be pay by BTC or LTC
> 
> * Real BTC and/or LTC are used to pay for transaction fee on the Bitmark main chain
> 
> * Testnet BTC and/or LTC are used to pay for transaction fee on the Bitmark testing chain

<br>
<br>

## Bitmark shares related records

There are three records related to the Bitmark shares are stored on the Bitmark blockchain 

* *Balance Record* - created by a bitmark owner to permanently set the total number of a particular share for the bitmark.

* *Grant Record* - created by an owner to grant an amount of his share balance to another owner.

* *Swap Record* - created by two owners to swap their shares of different bitmarks together.

<br>
<br>

## Prerequisites of working with bitmark shares using the Bitmark CLI

Refer the [Payment on Bitmark CLI](payment-on-bitmark-cli.md) document to: 

* Install the Bitmark-Wallet

* Install the bitcoind or litecoind

* Link the Bitmark-Wallet with the bitcoind or litecoind

* Get `testnet` bitcoin or litecoin.

<br>
<br>

## Creating bitmark shares

Any bitmark owner is able to create shares of a particular bitmark, that action divides the bitmark into a number of shares

* The initial number of shares is not changable after created.

* Once the bitmark is converted into shares, it cannot be transferred anymore. The provenance of the bitmark is terminated.

* All the created shares are alocated to the owner.

* A share creation transaction costs 0.002 LTC or 0.0002 BTC as the transaction fee

<br>

### Creating bitmark shares from a bitmark

  ```shell
    $ bitmark-cli -n <network> -i <identity> \ 
      share -t <txid> -q <quantity>
  ```

  >The `share` command is to create shares of a bitmark. The options:
  >
  >* `identity` - The bitmark owner's identity.
  > 
  >* `txid` - The latest transaction id in the bitmark's provenance.
  >
  >* `quantity` - The number of shares.
  >
  >The returns:
  >
  >* `txid` - The transaction id of the share creation.
  >
  >* `shareId` - The share id which is also the bitmark id.
  >
  >* The payment information (payId, currency, address, amount).


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

<br>

### Paying for the bitmark share creation using the Bitmark-Wallet

  ```shell
    #Run the bitcoind 
    $ bitcoind -datadir=<bitcoind config dir>

    # OR run the litecoind 
    $ litecoind -datadir=<litcoind config dir>

    #Pay by BTC
    $ bitmark-wallet --conf <Bitmark-Wallet config file> btc --<btc network> \ 
      sendmany --hex-data '<payId>' '<btc address>,<btc amount in satoshi>'

    #OR Pay by LTC
    $ bitmark-wallet --conf <Bitmark-Wallet config file> ltc --<ltc network> \ 
      sendmany --hex-data '<payId>' '<ltc address>,<ltc amount in photon>'

  ```
  
  >To execute a bitcoin or litecoin transaction on the local environment, the bitcoind or litecoind need to be running.
  >
  >* `payId` - The payment id for the share creation transaction, it is printed in the output of share creation command

<br>

  >**NOTE:** The payment is able to be performed using another tool which allows users to add the exact hex data to an OP_RETURN as part of the coin transaction

*Example:* 

* Run bitcoind

  ```shell
    $ bitcoind -datadir=${HOME}/.config/bitcoin/
  ```

<br>

* Pay for the transaction by bitcoin using the Bitmark-Wallet 

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

<br>

### Verifying the status of the share creation transaction

  ```shell
    $ bitmark-cli -n <network> \ 
      status -t <txid>
  ```

  >The `status` command is to query a transaction's status. The options:
  >
  >* `txid` - The transaction id which is printed in the output of the share creation command.
  >
  >The returned status:
  > 
  >* `Pending` - Has not been paid.
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

    //Check again fter several minutes
    {
      "status": "Confirmed"
    }
  ```

<br>

### Verifying that the share has been created and allocated to the owner

  ```shell
    $ bitmark-cli -n <network> \
      balance -o <ownwer identity>

  ```

  >The `owned` command is to list out all the bitmarks and shares are being owned by a user. The options:
  >
  >* `owner identity` - The identity of the owner of the bitmark from which the shares are created.


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

<br>
<br>

## Granting bitmark shares to another account

Any owner with a non-zero share balance can grant shares from that balance to another account. 

A grant share transaction is a two signature transaction. Therefore, the current share owner initializes the transaction and the new owner needs to sign to accept the shares. 

  ```shell
    # The current owner initializes the grant shares transaction
    $ bitmark-cli -n <network> -i <current owner identity> \
      grant -r <receiver> -s <shareid> -q <quantity>

    # The receiver signs to accept the shares
    $ bitmark-cli -n <network> -i <receiver identity> \
      countersign -t <hex-data>
  ```

  >The `grant` account allows a bitmark shares owner to grant some of his share balance to another account. Only after the new owner signs to accept the shares, the grant transaction is created and submitted to the blockchain. The `grant` command options:
  >
  >* `receiver` - The identity of the new owner of the granted shares.
  >
  >* `shareid` - The share id (share id = bitmark id).
  >
  >* `quantity` - The number of granted shares.
  >
  >The returns:
  >
  >* `identity` - The account number of the current share owner.
  >
  >* `grant` - The hex-data which needs to be signed by the new owner.
  >
  >
  >The `countersign` command is used to sign for a data. In this case, it is used by the `receiver` to sign for accepting the shares.
  >
  >* `<hex-data>` - The grant data is returned by the `grant` command.
  >
  >
  >**NOTE:** The grant shares transaction cost a transaction fee of 0.001 LTC or 0.0001 BTC. Only when the fee is paid, the transaction is able to be confirmed on the blockchain.


*Example:* 

* The current owner initializes the grant share transaction
  
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

<br>

* The new owner signs to accept the shares

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

<br>

* Pay for the grant shares transaction by LTC

  ```shell
    $ bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf \
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

<br>

* Verify the grant shares transaction status

  ```shell  
    $ bitmark-cli -n testing \
      status -t \
      fc88099d56c6f33bd90eb35937aa5d6e875c00017e7a78046ab3e5279b337e57
  ```
  ```json
    {
      "status": "Verified"
    }

    //Check again after several minutes
    {
      "status": "Confirmed"
    }
  ```

<br>

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

<br>

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

<br>
<br>

## Swapping bitmark shares

Two owners of different bitmark shares are able to swap their shares together. The swap requires signatures from both owners.

A swap share transaction is a two signature transaction. Therefore, both the owners need to sign to transfer and accept the corresponding shares.

  ```shell
    # One of the owner initializes the swap shares transaction
    $ bitmark-cli -n <network> -i <owner identity> \
      swap -r <receiver> -s <shareId1> -q <quantity1> \
      -S <shareId2> \
      -Q <quantity2> \ 
      -b <block_number>


    # The other owner (the receiver) signs to swap the shares
    $ bitmark-cli -n <network> -i <receiver identity> \
      countersign -t <hex-data>
  ```

  >The `swap` command is to initialize a swap shares request, the request needs to be sign by the sender. Once the receiver signs to accept the request, the swap shares transaction is created and submitted to the blockchain. The `swap` command options:
  >
  >* `receiver` - The receiver's identity.
  >
  >* `shareId1` - The id of the sender's shares.
  >
  >* `quantity1` - The number of shares that the sender wants to swap with the receiver.
  >
  >* `shareId2` - The id of the receiver's shares for which the sender wants to swap.
  >
  >* `quantity2` - The number of the receiver's shares for which the sender wants to swap.
  >
  >* `block_number` - This provides a time-limit to let the request expire and become invalid. Every 30 blocks from the current block adds one hour of expiration.
  >
  > 
  >The `countersign` command is used to sign for a data. In this case, it is used by the `receiver` to sign for swapping the shares.
  >
  >* `<hex-data>` - The data is returned by the `swap` command.
  >
  >
  >**NOTE:** The grant shares transaction cost a transaction fee of 0.001 LTC or 0.0001 BTC. Only when the fee is paid, the transaction is able to be confirmed on the blockchain.

*Example:*

* One of the owner to initialize the swap shares request

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

<br>

* The receiver signs to accept swapping the shares

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

<br>

* Pay for the swap share transaction

  ```shell
    $ bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf \
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

<br>

* Verify the swap shares transaction status

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

    // Check again after several minutes
    {
      "status": "Confirmed"
    }
  ```

<br>

* Check the balance of the first owner

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

<br>

* Check the balance of the other owner

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
