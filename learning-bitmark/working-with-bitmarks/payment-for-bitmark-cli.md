# Bitmark transaction payment

In the Bitmark Property System, for each asset, each Bitmark Account is able to issue a bitmark for free, and has to pay for all the other transactions such as bitmark transfers or other bitmark issuances.

The Bitmark CLI submits transactions to its connected node via RPC. Once receiving these transactions, the node processes them and returned the corresponding payment ids along with the payment amounts and addresses. Only when the payment - either by bitcoin or litecoin - is executed, a transaction is updated from `Pending` to `Verified` and is ready to be mined. The payment transaction needs to send:

* A correct amount

* To the correct address

* With the correct payment id added as bitcoin/litecoin OP_RETURN opcode.

Because common wallets do not support attaching the Bitmark blockchain payment identifier to the ltc/btc transactions, we provide an app called the Bitmark Wallet to pay for the Bitmark transactions come from the Bitmark CLI.

<br>
<br>

## Bitmark Wallet

The Bitmark Wallet is a dual currency wallet, supporting both bitcoin and litecoin. It allows sending multiple payments to different addresses and attaching a hex data item to a transaction using the OP_RETURN feature of bitcoin/litecoin.

The wallet is written in Go and cannot work standalone, it can only send the bitcoin and litecoin transactions via a correct configured bitcoind and litecoind. Depending on the configuration of bitcoind and litecoind, the payment transactions are submitted to the mainnet coins or testnet coins.

Supported commands:

* Submit btc/ltc transactions.

* Update the wallet from the btc/ltc block chain - for this it will query its local daemon to request any transctions belonging to its addresses.

* Display the wallet balance for each coin.

* Generate and display an address that can be used to send more coins to the wallet.

> **NOTE:**The Bitmark Wallet uses a master bip39 based recovery phrase which must be printed and kept safe.

<br>

Next steps:

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
        $ mkdir ${HOME}/.config/bitmark-wallet
        $ touch ${HOME}/.config/bitmark-wallet/bitmark-wallet.conf
    ```

<br>

* Copy the content from the [sample config file](samples/bitmark-wallet.conf) to the created config file above

<br>
<br>

### Connect the Bitmark Wallet with bitcoind and litecoind

* Download the [rpcauth.py](samples/rpcauth.py)

<br>

* Get the ltc and btc rpcauth, rpc username, and rpc password by running

    ```shell
        $ python3 rpcauth.py localhost
    ```

<br>

* Copy the btc and ltc username and password and paste to the corresponding field in the bitmark-wallet.conf

    *Example:*
    ```
        agent {
          ltc {
            type = "daemon"
            node = "localhost:19332"
            user = "sfkrvwbjdqtmwrewxfjkowrs"
            pass = "8D0PFG7t_lhfdhPa1IWs-AZxuHI41X3q9S8QRKScIrw="
          }
          btc{
            type = "daemon"
            node = "localhost:18332"
            user = "mhvvmfdcucaustjpzuiavokq"
            pass = "Ft6lkX3wB_9I0kioqGkkxuVxD072bMUkCnwTlmjgKoc="
          }
        }
    ```

<br>

* Copy the corresponding rpcauth and past to the  litecoin and bitcoin config files

    *Example:*
    ```
    #In litecoin.conf:

        # authentication
        rpcauth=sfkrvwbjdqtmwrewxfjkowrs:13b9cd202435e8696f050fa899ad64$a24cb045e3cd0fac9d5659a7073aea9787bac818989c08d5acb1465c4db79b11
    ```

    ```
    # In bitcoin.conf:

        # authentication
        rpcauth=mhvvmfdcucaustjpzuiavokq:3088a1682d42acc444abe51e8d3c3e$ec512a3538ada3b4ef55ea8dd1eadc82d274c908eda094c04924e50220e808ee
    ```

<br>

> **NOTE:** Transactions on the Bitmark testnet blockchain need to be paid by the testnet coins. To do so, enable the testnet by adding `testnet=1` field to the bitcoind/litecoind config files.

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




