---
title: Bitmark transaction payment
keywords: transaction payment
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/working-with-bitmarks/payment-for-bitmark-cli
folder: learning-bitmark/quick-start/working-with-bitmarks
---

# Bitmark transaction payment

Bitmark transaction fees can be paid in either Bitcoin or Litecoin cryptocurrencies.

The Bitmark CLI submits transactions to its connected Bitmark Node via RPC. Once the server receives these transactions, it processes them and returns corresponding payment ids, amounts, and addresses. The transaction is only updated from Pending to Verified, making it ready to be mined, once a payment is executed, either in bitcoin or litecoin.

In order for bitcoin or litecoin payment to be correctly recognized, freeing up the Bitmark transaction, it must include:

* A correct amount

* To the correct address

* With the correct payment id added as bitcoin/litecoin OP_RETURN opcode.

Because common wallets do not support attaching the Bitmark blockchain payment identifier to the ltc/btc transactions, we provide an app called the Bitmark Wallet to pay for the Bitmark transactions come from the Bitmark CLI.

<br>
<br>

## Bitmark Wallet

The Bitmark Wallet is a dual currency wallet, supporting both bitcoin and litecoin. It allows sending multiple payments to different addresses and attaching a hex data item to a transaction using the OP_RETURN feature of bitcoin/litecoin.

The wallet is a command-line tool which is written in Go and cannot work standalone, it can only send the bitcoin and litecoin transactions via a correct configured bitcoind and litecoind. Depending on the configuration of bitcoind and litecoind, the payment transactions are submitted to the mainnet coins or testnet coins.

Features:

* Submit btc/ltc transactions.

* Update the wallet from the btc/ltc block chain - for this it will query its local daemon to request any transctions belonging to its addresses.

* Display the wallet balance for each coin.

* Generate and display an address that can be used to send more coins to the wallet.

> **NOTE:**The Bitmark Wallet uses a master bip39 based recovery phrase which must be printed and kept safe.

<br>
<br>

## Instructions for Using the Bitmark Wallet

The next sections explain the main actions involved with using the Bitmark wallet including how to:

* Install the Bitmark Wallet.

* Sync the wallet with the coins.

* Run the wallet.

* Get the testnet coins.

<br>
<br>

### Prerequisites of installing the Bitmark Wallet

* Git has been installed.

* Go has been installed.

* Python3 is installed.

* bitcoind/litecoind have been installed.

<br>
<br>

### Installing the Bitmark Wallet

* Clone the Bitmark Wallet

    ```shell
        $git clone https://github.com/bitmark-inc/bitmark-wallet.git
    ```

<br>

* Install the Bitmark Wallet

    ```shell
        $cd bitmark-wallet/command/bitmark-wallet

        $go install
    ```

<br>

* Create Bitmark Wallet's config file

    ```shell
        $ touch <CONFIG DIR>/bitmark-wallet/bitmark-wallet.conf
    ```

    *Example:*
    ```shell
        $ mkdir ~/.config/bitmark-wallet
        $ touch ~/.config/bitmark-wallet/bitmark-wallet.conf
    ```

<br>
<br>

### Connect the Bitmark Wallet with bitcoind and litecoind

The Bitmark Wallet comunnicate with litecoind and bitcoind using RPC so the RPC needs to be enabled in the bitcoin.conf and litecoin.conf and the corresponding rpc username / password needs to be added into the Bitmark Wallet config file.

* Enable RPC in the coins config files

    ```#bitcoin.conf

        # RPC server port
        rpcport = 18332
        rpcbind = 127.0.0.1
        rpcbind = [::1]

        # RPC configuration
        rpcthreads = 20
        #rpcssl = 1
        rpcallowip = 127.0.0.1
        rpcallowip = [::1]

        # authentication
        rpcauth=<rpc auth line for bitcoin>
    ```


    ```#litecoin.conf

        # RPC server port
        rpcport = 19332
        rpcbind = 127.0.0.1
        rpcbind = [::1]

        # RPC configuration
        rpcthreads = 20
        #rpcssl = 1
        rpcallowip = 127.0.0.1
        rpcallowip = [::1]

        # authentication
        rpcauth=<rpc auth line for bitcoin>
    ```

<br>

* Run the [rpcauth.py](samples/rpcauth.py) program to get the rpcauth lines and corresponding usernames & passwords

    ```shell
        $ python3 rpcauth.py localhost
    ```
    ```json
        btc:
            localhost:
              rpcauth:  "cotzntmnxllhcpsshvdzzuue:1c1671f8ffbdd8d845688dc450d2c4e1$ec4723c3a7c29d072c40749017d4d326576c68264595355fac8816d525220f7a"
              username: "cotzntmnxllhcpsshvdzzuue"
              password: "vN9v95_7qjWiHSMUx2QuriX6fUgjoPyZgJRm-1Og0-g="
          ltc:
            localhost:
              rpcauth:  "wzrhjmlikroaxjnckmgzcrfv:37ff59f93e737d95f3cb15a4c5b81d$ecf9e7d5ceaf79fa136865d950c64b88845582e78f4a7af5e8a1861ad8331f08"
              username: "wzrhjmlikroaxjnckmgzcrfv"
              password: "7iLL9pGM7W4LNQTjDmdYGj6mJ7nBFgYIix5OjRbR-v4="
    ```

<br>

* Copy the corresponding rpcauth lines and paste to the  litecoin and bitcoin config files

    *Example:*
    ```
    #In litecoin.conf:

        # authentication
        rpcauth=wzrhjmlikroaxjnckmgzcrfv:37ff59f93e737d95f3cb15a4c5b81d$ecf9e7d5ceaf79fa136865d950c64b88845582e78f4a7af5e8a1861ad8331f08
    ```

    ```
    # In bitcoin.conf:

        # authentication
        rpcauth=cotzntmnxllhcpsshvdzzuue:1c1671f8ffbdd8d845688dc450d2c4e1$ec4723c3a7c29d072c40749017d4d326576c68264595355fac8816d525220f7a
    ```

<br>

* Copy the btc and ltc prc usernames and passwords and paste to the corresponding fields in the bitmark-wallet.conf

    *Example:*
    ``` # bitmark-wallet.conf
        agent {
          btc{
              type = "daemon"
              node = "localhost:18332"
              user = "cotzntmnxllhcpsshvdzzuue"
              pass = "vN9v95_7qjWiHSMUx2QuriX6fUgjoPyZgJRm-1Og0-g="
          }
          ltc {
            type = "daemon"
            node = "localhost:19332"
            user = "wzrhjmlikroaxjnckmgzcrfv"
            pass = "7iLL9pGM7W4LNQTjDmdYGj6mJ7nBFgYIix5OjRbR-v4="
          }
        }
    ```

<br>

> **NOTE:** Transactions on the Bitmark blockchain need to be paid by real bitcoin and/or litecoin. And the transactions on the Bitmark testnet blockchain need to be paid by the testnet coins.

<br>
<br>

### Run the Bitmark Wallet

* Run the coin servers

    ```shell
        # bitcoind
        $ bitcoind -datadir=<bitcoind config dir>
    ```
    ```shell
        # litecoind
        $ litecoind -datadir=<litecoind config dir>
    ```

    *Example:*
    ```shell
        # bitcoind
        $ bitcoind -datadir=${HOME}/.config/bitcoin
    ```
    ```shell
        # litecoind
        $ litecoind -datadir=${HOME}/.config/litecoin
    ```

<br>

* Init the bitmark wallet

    ```shell
        $  bitmark-wallet --conf=<conf file> init
    ```

    *Example:*
    ```shell
        # bitcoind
        $ bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf init
    ```

<br>

* Sync the wallet with the coins 

    > The syncing is to scan the blockchain from the block that was highest at the time it was last used to the current block height to see if any transactions matching any addresses in the wallet were sent.

    ```shell
        # bitcoin
        $ bitmark-wallet --conf=<config file> btc sync --testnet
    ```
    ```shell
        # litecoin
        $ bitmark-wallet --conf=<config file> ltc sync --testnet
    ```

    *Example:*
    ```shell
        # bitcoind
        $ bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf \
          btc sync --testnet
    ```
    ```shell
        # litecoind
        $ bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf \
          ltc sync --testnet
    ```

<br>

* Generate the btc/ltc addresses

    ```shell
        # bitcoin
        $ bitmark-wallet --conf=<config file> btc newaddress --testnet
    ```
    ```shell
        # litecoin
        $ bitmark-wallet --conf=<config file> ltc newaddress --testnet
    ```

    *Example:*
    ```shell
        # bitcoind
        $ bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf \
          btc newaddress --testnet
    ```
    ```shell
        # litecoind
        $ bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf \
          ltc newaddress --testnet
    ```

<br>
<br>

### Get testnet coins

* Get some testnet litecoins at https://faucet.xblau.com/

* Get some testnet bitcoins at https://coinfaucet.eu/en/btc-testnet/




