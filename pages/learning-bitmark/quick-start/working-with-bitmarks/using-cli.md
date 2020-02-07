---
title: Using the CLI
keywords: bitmark, account, transaction
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/using-the-cli
folder: learning-bitmark/quick-start/working-with-bitmarks
---

# Using the CLI

This section introduces simple commands to create a new Bitmark Account, execute some simple transactions using the Bitmark-CLI. For the command structures, detailed explanations, and other functions please refer the [Bitmark-CLI](../../../bitmark-references/bitmark-cli/bitmark-cli.md) documents.

## The Basics of CLI commands

All Bitmark-CLI commands follow the same basic structure:

`$ bitmark-cli [global-options] command [command-options]`
    
You will need to send the Bitmark-CLI the global option `--network` (abbreviation: `-n`) to identify the network that you are sending the command to.

**Network Options:**
* `bitmark`:  the live network, which uses live BTC or LTC to pay for the transactions.
* `testing`:  a network for testing newly developed programs, which uses testnet coins to pay for transactions.
* `local`: a special case for running a regression test network on the loopback interface.

## Prerequisites

The `bitmark-wallet` software is required for paying for transactions. Please refer to the [CLI payment](payment-for-bitmark-cli.md) document for instructions on installing it.

## Creating a Bitmark Account

To create a Bitmark Account using the BitmarkCLI:

* Install [Bitmark-CLI](../../../bitmark-references/bitmark-cli/bitmark-cli.md)

* Initialize the Bitmark-CLI configuration

    ```shell
    $ bitmark-cli -n <network> -i <identity> \
    setup -c <node>:2130 -d '<description>' -n
    ```

    >The `setup` command initializes the Bitmark-CLI config file.
    >
    > **Global Options:**
    >* `network` - The network to which the command is sent.
    >* `identity` - The identity of the Bitmark-CLI user.
    >
    > **Command Options:**
    >* `node` - The Bitmark node to which the Bitmark-CLI connects and submits its transactions.
    >* `description` - The identity’s description. 
    >* `-n` (abbr. of --new) - A new account is being created.
    
    *Example:*
 
    ```shell
    $ bitmark-cli -n testing -i first \
    setup -c 128.199.89.154:2130 -d 'first user' -n
    ```
    > This command creates a user on the testing network using the node 128.199.89.154:2130 with the user having an identity of "first" and a description of "first user".

*  Add an additional Bitmark account
    ```shell
    $ bitmark-cli -n <network> -i <identity> \
    add -d '<description>' -n
    ```
    > The `add` command adds a new user after the Bitmark-CLI configuration was initialized. 
    > The command options have the same meanings as in the `setup` command.
    
    *Example:*  
    ```shell
    $ bitmark-cli -n testing -i second \
    add -d 'second user' -n
    ```

* Check the account numbers
    ```shell
    $ bitmark-cli -n <network> list
    ```

    > The `list` command lists all the users of the Bitmark-CLI.
    
    *Example:*

    ```shell
    $ bitmark-cli -n testing list
    ```
    ```
    SK first    fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A  "first user"
    SK second   fPWWkW45o12er6oP4EveaURHXstkSXR3odWCgpaDvEvxoR3woC  "second user"
    ```


* Get the account seed and recovery phrase for an identity
    ```shell
    $ bitmark-cli -n <network> -i <identity> seed
    ```

    > The `seed` command prints out all the information about a Bitmark-CLI user. 
    
    *Example:*
 
    ```shell
    $ bitmark-cli -n testing -i first seed
    ```
    ```json
    {
        "privateKey": "BQVdbCAVQ1KHv4sDSQ5d874BfZYmLeeJveNGXThxU4WKh5K39o6eEVqoBZFKbJWHiJgkyYThnBFdfF9bgSGmhyDLsk7oR9",
        "seed": "9J87ApGrXzDitFk8eviHf31RNXbTcjW8S",
        "description": "first user",
        "name": "first",
        "account": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
        "recovery_phrase": "lamp between sponsor butter lawn ski venture autumn anger corn bullet catalog"
    }
    ```

**NOTE:** 

* The account creation commands require users to provide and confirm a password.
* All identity-required commands ask for the account password. For example, the `seed` command requires it because it outputs sensitive data.

## Registering Bitmark Certificates

To register a new property using the Bitmark-CLI:

* Compute the hash of an asset

    ```shell
    $ bitmark-cli -n <network> \
    fingerprint -f <file>
    ```

    > The `fingerprint` command computes the hash of a file
    >
    > **Command Options:**
    > * `file` - The file from which the hash is computed.

    *Example:*

    ```shell
    $ bitmark-cli -n testing \
    fingerprint -f test.txt
    ```
    ```json
    {
        "file_name": "filename.test",
        "fingerprint": "0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500"
    }
    ```

* Issue the first Bitmark Certificate

    ```shell
    $ bitmark-cli -n <network> -i <identity> \
    create -a '<asset name>' \
    -m '<asset metadata>' \
    -f <asset fingerprint> \
    -z
    ```

    > The `create` command registers an asset from a fingerprint *and* issues the corresponding bitmarks
    >
    > **Global Options:**
    >* `identity` - The identity of the registrant's Bitmark Account, which is stored in the Bitmark-CLI config file. 
    >
    > **Command Options:**
    >* `asset name` - The `name` field in the asset record.
    >
    >* `asset metadata` - The `metadata` field in the asset record.
    >
    >* `asset fingerprint` - The hash of the asset.
    >
    >* `-z` option - This is the first Bitmark issued for the asset.

    *Example:*

    ```shell
    $ bitmark-cli -n testing -i first \
    create -a 'Example asset' \
    -m 'Key1\u0000Value1\u0000Key2\u0000Value2' \
    -f 0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500 \
    -z
    ```
    ```json
    {
        "assetId": "dac17bef505f7a5acf890a1d0f232b7d847f1e951cf1f5b880de13253a10df43cdbcab553e08050808e0b3fdfd2581a798dcdf9cedbbddf4476ead14caa612d3",
        "issueIds": [
            "b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23"
        ],
        "payId": "b30bf53de9f6ae5ca59259fd695566bce692d422201c222ff136ab3193f16301e055b1030ce46a1981f439105b3a96e2",
        "payNonce": "a7b23fc462594028",
        "difficulty": "0000ffffffffffffff8000000000000000000000000000000000000000000000",
        "submittedNonce": "00000001a67fa973",
        "proofStatus": "Accepted"
    }
    ```

* Verify the status of the Bitmark issuance transaction

    ```shell
    $ bitmark-cli -n <network>\
      status -t <txid>
    ```

    > The `status` commands checks if a Bitmark has been issued
    >
    >**Command Options:**
    >* `txid` — The transaction being verified, corresponding to the `issueIds` from the `create` command
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
      b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23
    ```

    ```json
    // Check right after the create command
    {
      "status": "Pending"
    }

    // Check again after some minutes
    {
      "status": "Confirmed"
    }
    ```

## Transferring bitmarks using the Bitmark-CLI

The Bitmark-CLI allows users to transfer bitmarks by submitting the transactions to its connected node and then broadcasting to the network.

To transfer a Bitmark Certificate using the Bitmark-CLI:

* Submit a transfer request

    ```shell
    $ bitmark-cli -n <network> -i <sender identity>\
      transfer -r <receiver> \
      -t <txid> -u
    ```
    
    > The `transfer` command submits a transfer transaction to the network. 
    >
    > **Global Options:**
    >* `sender identity` - The identity of the sender's Bitmark Account, which is stored in the Bitmark-CLI config file
    >
    > **Command Options:**
    >* `receiver` - The identifier of the recipient's Bitmark Account. This can be a Bitmark Account Number or the Bitmark Account's identity, if it's stored in the Bitmark-CLI config file
    >
    > `txid` - The id of the last transaction of the Bitmark that is being transferring.
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

    //Check again fter some minutes
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

    >The `provenance` command returns all the transaction records related to an asset from the transaction corresponding to the txid back to the Bitmark's asset registration record. 
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
