---
title: Transferring Bitmark Certificates
keywords: transaction, transfer
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/working-with-bitmarks/transferring-bitmarks
folder: learning-bitmark/quick-start/working-with-bitmarks
---

# Transferring Bitmark Certificates

Once an asset has been registered, the owner can trade it by creating a transfer record that points back to the original issue record (or to a previous transfer record) and that lists the new owner of the asset. Because the blockchain is ordered and because it's immutable, this creates a permanent chain of custody reaching back to the asset's origins.

Bitmark owners can transfer their Bitmark Certificates to others using the SDK and the CLI.

## Prerequisites

**Using the SDK**
* [Install the SDK](sdk/getting-started.md#installing-sdk-packages)
* [Acquire an API token](sdk/getting-started.md#acquiring-an-api-token)

**Using the CLI**
* [Install the CLI along with the bitmarkd](run-a-node.md)
* [Install and configure the Bitmark Wallet](cli/cli-payment.md#installing-and-configuring-the-bitmark-wallet)

* Submit a transfer transaction

    ```js
        let transferParams = Bitmark.newTransferParams(recipientAccount);
        await transferParams.fromBitmark(bitmarkid);
        transferParams.sign(sender);

        let txs = (await Bitmark.transfer(transferParams)).txs;
        let txId = txs[0].id;
    ```

* Verify the transfer transaction

    ```js
        await Transaction.get(txId);
    ```

## Transferring bitmarks using the Bitmark CLI

The Bitmark CLI allows users to transfer bitmarks by submitting the transactions to its connected node and then broadcasting to the network.

To transfer a Bitmark Certificate using the Bitmark CLI:

* Submit a transfer request

    ```shell
    $ bitmark-cli -n <network> -i <sender identity>\
      transfer -r <receiver> \
      -t <txId> -u
    ```
    
    > The `transfer` command submits a transfer transaction to the network. 
    >
    > **Global Options:**
    >* `sender identity` - The identity of the sender's Bitmark Account, which is stored in the Bitmark CLI config file
    >
    > **Command Options:**
    >* `receiver` - The identifier of the recipient's Bitmark Account. This can be a Bitmark Account Number or the Bitmark Account's identity, if it's stored in the Bitmark CLI config file
    >
    > `txId` - The id of the last transaction of the Bitmark that is being transferring.
    >
    >**NOTE:** A transfer transaction on the Bitmark blockchain requires a transaction fee of 0.0002 BTC (20000 satoshis) or 0.002 LTC (200000 photons). Therefore, after the `transfer` command, the user will need to execute the payment on the Bitcoin or Litecoin blockchain. This payment information is included in the output of the `transfer` command.
    >
    > The transfer command also auto generates the `bitmark-wallet` commands for paying for the transaction and displays them at the end of the output.


    *Example:*

    ```shell
    $ bitmark-cli -n testing -i first\
      transfer -r second \
      -t 6b35dfb5d623f6cae22fd03b3e28f1fde5255a29c1328a5d39ddfdfcd0ce6cf9 -u
    ```
    ```json
    {
      "transferId": "4656604222152d08606d42a40c8590c2100c177cafe374ea90bae30c5bd371e0",
      "bitmarkId": "7e3337ae7596864e6dfd918c07780480ef80cea96fa039ed17d35c3849fcb3ca",
      "payId": "d819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e",
      "payments": {
        "BTC": [
          {
            "currency": "BTC",
            "address": "mr8DEygRvQwKfP4sVZuHVozqvzW89e193j",
            "amount": "20000"
          }
        ],
        "LTC": [
          {
            "currency": "LTC",
            "address": "mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds",
            "amount": "200000"
          }
        ]
      }
    },
    "commands": {
      "BTC": "bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf btc --testnet sendmany --hex-data 'd819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e' 'mnTuuYNZmmswFT8iqr7ex82HAQYLJ8LXkC,10000' 'mr8DEygRvQwKfP4sVZuHVozqvzW89e193j,20000'",
      "LTC": "bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf ltc --testnet sendmany --hex-data 'd819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e' 'mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds,200000'"
    }
    ```


* Pay for the bitmark transfer using `bitmark-wallet`

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

    >To execute a bitcoin or litecoin transaction on the local environment, the `bitcoind` or `litecoind` daemon must be running.
    >
    > - `payId` - The payment id for the transfer transaction, printed in the results as `payId`
    > - `btc address` or `ltc address` - The address for payment, printed in the results as `address` under `BTC` or `LTC`
    > - `btc amount` or `ltc amount` - The payment amount, printed in the results as `amount` under `BTC` or `LTC`

    *Example — Paying by LTC:*

    ```shell
    # run litecoind
    $ litecoind -datadir=~/.config/litecoin/

    # Perform payment
    $ bitmark-wallet --conf ~/.config/bitmark-wallet/test/test-bitmark-wallet.conf \
      ltc --testnet \
      sendmany --hex-data \
      'd819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e' \
      'mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds,200000'
    ```
    ```json
    {
      "txId": "ca94ae188ba8bfdc42e026950c5e13a2f1082dae484a45c5dc29217ac0c9a23f",
      "rawTx": "0100000001b76a37054a086c5bd68afd61914bb4badc78c9e7ef59e6b692777cc18063632d020000006b483045022100db6f27ec3e1e59c34887f262217d5ff819947c561f0ecd11034ba8b32dbdc87002203ef82d80be8e43434eb16e22248e4533a1d3c2831e19802ce55a308604d76f3c012103b45a55c3e48209581d63ba5ceea9a0e94ae49e18056d85a6dadec535dbe237a2ffffffff03400d0300000000001976a914d2ebb7b259fb7410dca19b707c4091195d818ac488ac8091e305000000001976a9142d477753d17099534f9249b54cda36081d4e5eba88ac0000000000000000326a30d819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e00000000"
    }
    ```

* Verify the status of the transfer transaction

    ```shell
    $ bitmark-cli -n <network> \
      status -t <transferId>
    ```

    >The `status` command queries a transaction's status.
    >
    >**Command Options:**
    >* `transferId` - The transfer transaction id, printed as `transferId` in the output of the `transfer` command.
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
      4656604222152d08606d42a40c8590c2100c177cafe374ea90bae30c5bd371e0
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

* Verify the Bitmark's provenance

    ```shell
    $ bitmark-cli -n <network> \
      provenance -t <transferID>
    ```

    >The `provenance` command returns all the transaction records related to an asset from the transaction corresponding to the txId back to the Bitmark's asset registration record. 
    >
    > **Command options:**
    >* `transferID` - `transferId` - The transfer transaction id, printed as `transferId` in the output of the `transfer` command

    *Example:*

    ```shell
    $ bitmark-cli -n testing \
      provenance -t \
      4656604222152d08606d42a40c8590c2100c177cafe374ea90bae30c5bd371e0
    ```
    ```json
    {
      "data": [
        {
          "record": "BitmarkTransferUnratified",
          "isOwner": true,
          "txId": "4656604222152d08606d42a40c8590c2100c177cafe374ea90bae30c5bd371e0",
          "inBlock": 31101,
          "data": {
            "escrow": null,
            "link": "7e3337ae7596864e6dfd918c07780480ef80cea96fa039ed17d35c3849fcb3ca",
            "owner": "fPWWkW45o12er6oP4EveaURHXstkSXR3odWCgpaDvEvxoR3woC",
            "signature": "1d378c7e...7dafcc02"
          },
          "_IDENTITY": "second"
        },
        {
          "record": "BitmarkIssue",
          "isOwner": false,
          "txId": "7e3337ae7596864e6dfd918c07780480ef80cea96fa039ed17d35c3849fcb3ca",
          "inBlock": 31100,
          "data": {
            "assetId": "813b2eb5...de9219a7",
            "nonce": 0,
            "owner": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
            "signature": "4581ee97...9b24f20f"
          },
          "_IDENTITY": "first"
        },
        {
          "record": "AssetData",
          "isOwner": false,
          "inBlock": 31100,
          "assetId": "813b2eb5...de9219a7",
          "data": {
            "fingerprint": "01cdb27c...50514f0c",
            "metadata": "Key1\u0000Value1\u0000Key2\u0000Value2",
            "name": "Example asset 3",
            "registrant": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
            "signature": "d6cc18e5...47efe909"
          },
          "_IDENTITY": "first"
    }
    ```
    
## Exploring Bitmark transactions using the Bitmark Registry website

Users can explore all of the transactions on the Bitmark blockchain using the Bitmark Registry web application:

* For transactions on the Bitmark livenet blockchain: https://registry.bitmark.com

* For transactions on the Bitmark testnet blockchain: https://registry.test.bitmark.com
