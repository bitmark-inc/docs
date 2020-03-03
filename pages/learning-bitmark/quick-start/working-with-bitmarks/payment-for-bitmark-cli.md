---
title: Bitmark CLI Payment
keywords: transaction payment
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/working-with-bitmarks/bitmark-cli-payment
folder: learning-bitmark/quick-start/working-with-bitmarks
---

# Paying for Bitmark Transactions

Bitmark transaction fees for transfers and share-related transactions can be paid in either Bitcoin (BTC) or Litecoin (LTC) cryptocurrencies. 

The process is as follows:

The Bitmark CLI submits transactions to its connected Bitmark Node via RPC. Once the Node server receives a transaction, it processes the transaction, sets it as Pending, and returns corresponding payment IDs, amounts, and addresses. The transaction is only updated from Pending to Verified, making it ready to be mined, once a payment is executed, either in BTC or LTC.

In order for bitcoin or litecoin payment to be correctly recognized, freeing up the Bitmark transaction, it must include:

* A correct amount

* To the correct address

* With the correct payment ID added as a BTC/LTC OP_RETURN opcode.

Because common wallets do not support attaching the Bitmark blockchain payment identifier to the BTC/LTC transactions, Bitmark provides an app called the Bitmark Wallet to pay for Bitmark transactions that come from the Bitmark CLI.

## Bitmark Wallet

The Bitmark Wallet is a dual-currency wallet, supporting both bitcoin and litecoin. It allows a user to send multiple payments to different addresses and to attach a hex data item to a transaction using the OP_RETURN feature of BTC/LTC.

The wallet is a command-line tool which is written in Go and cannot work standalone; it can only send bitcoin and litecoin transactions via a correctly configured `bitcoind` and/or `litecoind`. Depending on the configuration of `bitcoind` and `litecoind`, the payment transactions are submitted as mainnet coins or testnet coins.

Features:

* Submit BTC/LTC transactions.

* Update the wallet from the BTC/LTC block chain by querying the local daemon to request any transaction belonging to its addresses.

* Display the wallet balance for each coin.

* Generate and display an address that can be used to send more coins to the wallet.

> **NOTE:**The Bitmark Wallet uses a master bip39-based recovery phrase, which must be printed and kept safe.


## Installing and configuring the Bitmark wallet

The main actions required to use the Bitmark wallet are:

* Installing the Bitmark Wallet.

* Syncing the wallet with coins.

* Running the wallet.

* Acquiring testnet coins.


### Prerequisites

To use the Bitmark Wallet:

* Git must be installed.

* Go must be installed.

* Python3 must be installed.

* `bitcoind`/`litecoind` must be installed.

### Installation

To install the Bitmark wallet:

* Clone the Bitmark Wallet

    ```shell
        $git clone https://github.com/bitmark-inc/bitmark-wallet.git
    ```

* Install the Bitmark Wallet

    ```shell
        $cd bitmark-wallet/command/bitmark-wallet

        $go install
    ```

* Create the Bitmark Wallet's config file

    ```shell
        $ touch <CONFIG DIR>/bitmark-wallet/bitmark-wallet.conf
    ```

    *Example:*
    ```shell
        $ mkdir ~/.config/bitmark-wallet
        $ touch ~/.config/bitmark-wallet/bitmark-wallet.conf
    ```

### Connecting with bitcoind and litecoind

The Bitmark wallet communicates with `litecoind` and `bitcoind` using RPC, so RPC needs to be enabled in the `bitcoin.conf` and `litecoin.conf` and the corresponding RPC username and password needs to be added into the appropriate config files.

* Enable RPC in the BTC and LTC config files

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
        rpcauth=<rpc auth line for bitcoin> [to be filled in later]
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
        rpcauth=<rpc auth line for bitcoin> [to be filled in later]
    ```

* Run the [`rpcauth.py`](samples/rpcauth.py) program to get the `rpcauth` lines and corresponding username & password

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

* Copy the corresponding `rpcauth` lines and paste them into the litecoin and bitcoin config files

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

* Copy the BTC and LTC RPC username and password and paste them into the corresponding fields in the `bitmark-wallet.conf`

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

> **NOTE:** Transactions on the main Bitmark blockchain need to be paid with real bitcoin and/or litecoin; transactions on the Bitmark testnet blockchain need to be paid with testnet coins.

### Running the wallet

To use the Bitmark Wallet:

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

* Initialize the Bitmark wallet

    ```shell
        $  bitmark-wallet --conf=<conf file> init
    ```

    *Example:*
    ```shell
        $ bitmark-wallet --conf=${HOME}/.config/bitmark-wallet/test/bitmark-wallet.conf init
    ```

* Sync the Wallet

    > Syncing scans the blockchain from the block that was highest at the time it was last used to the current block height to see if any transactions matching any addresses in the wallet were sent.

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

* Generate BTC/LTC addresses for sending coins

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

### Getting testnet coins

To fund a mainnet wallet, you'll need to send coins to the BTC or LTC address, but to fund a testnet wallet, you can simply request coins from a faucet.

* Get some testnet ltc at https://faucet.xblau.com/

* Get some testnet btc at https://coinfaucet.eu/en/btc-testnet/
