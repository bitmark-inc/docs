# Working with Bitmarks

Interacting with Bitmark requires the creation of a Bitmark Account. Afterward, users can register Bitmark Certificates for their digital properties, which they may later transfer to other users or divide into Bitmark shares.

Most work with the Bitmark Property System can be done via one of three methods: the [Bitmark App](https://a.bitmark.com/) (for iOS or Android), the [Bitmark SDK](https://github.com/bitmark-inc) (for a variety of programming languages), or the Bitmark CLI (available as part of a [Bitmark node](https://github.com/bitmark-inc/docs/blob/master/learning-bitmark/quick-start/simple-solution-for-node-setup.md)). 

* The **Bitmark App** is a simple mobile app that allows anyone to protect their legal rights to their data and other digital assets by registering them as properties on the Bitmark blockchain.

* The **Bitmark SDK** is a collection of libraries for different programming languages and mobile platforms. In addition to providing language-specific bindings for the Bitmark APIs, the SDK also simplifies local key management for signing and encryption.

* The **Bitmark CLI** is a command line tool that allows a user to interact with the Bitmark blockchain by connecting to one or several nodes in the network. All transactions are submitted directly to one of these connected nodes and consequently are verified by the node before being forwarded to the network.

These documents detail the usage of each of these methods. 

## [Working with Bitmark](working-with-bitmark.md)

* [Bitmark Account](working-with-bitmark.md#bitmark-account)
  * [Bitmark Account Number](working-with-bitmark.md#bitmark-account-number)
* [Bitmark Certificates](working-with-bitmark.md#bitmark-certificates)
* [Transactions](working-with-bitmark.md#transactions)
  * [Bitmark Certificate registration](working-with-bitmark.md#bitmark-certificate-registration)
  * [Bitmark Certificate transfer](working-with-bitmark.md#bitmark-cetificate-transfer)
* [Bitmark shares](working-with-bitmark.md#bitmark-shares)

## [Using the Bitmark app](using-bitmark-app.md)

* [Creating a Bitmark Account](using-bitmark-app.md#creating-a-bitmark-bccount)
* [Registering Bitmark Certificates](using-bitmark-app.md#registering-bitmark-certificates)
* [Transferring Bitmark Certificates](using-bitmark-app.md#transferring-bitmark-certificates)
* [Exploring bitmark transactions using the Bitmark Registry website](using-bitmark-app.md#exploring-bitmark-transactions-using-the-bitmark-registry-website)

## [Using the SDK](using-sdk.md)

* [Initializing the JS SDK](using-sdk.md#initializing-the-js-sdk)
* [Creating a Bitmark Account](using-sdk.md#creating-a-bitmark-bccount)
* [Registering Bitmark Certificates](using-sdk.md#registering-bitmark-certificates)
* [Transferring Bitmark Certificates](using-sdk.md#transferring-bitmark-certificates)
* [Exploring bitmark transactions using the Bitmark Registry website](using-sdk.md#exploring-bitmark-transactions-using-the-bitmark-registry-website)

## [Using the CLI](using-cli.md)

* [The Basics of CLI commands](using-cli.md#the-basic-of-cli-commands)
* [Prerequisites](using-cli.md#prerequisites)
* [Creating a Bitmark Account](using-cli.md#creating-a-bitmark-bccount)
* [Registering Bitmark Certificates](using-cli.md#registering-bitmark-certificates)
* [Transferring Bitmark Certificates](using-cli.md#transferring-bitmark-certificates)
* [Exploring bitmark transactions using the Bitmark Registry website](using-cli.md#exploring-bitmark-transactions-using-the-bitmark-registry-website)

## [CLI Payment](payment-for-bitmark-cli.md)

* [About the Bitmark Wallet](payment-for-bitmark-cli.md#about-the-bitmark-wallet)
* [Prerequisites](payment-for-bitmark-cli.md#prerequisites)
* [Using the Bitmark Wallet](payment-for-bitmark-cli.md#using-the-bitmark-wallet)
  * [Installing the Bitmark Wallet](payment-for-bitmark-cli.md#installing-the-bitmark-wallet)
  * [Connecting the Bitmark Wallet](payment-for-bitmark-cli.md#connecting-the-bitmark-wallet)
  * [Running the Bitmark Wallet](payment-for-bitmark-cli.md#running-the-bitmark-wallet)
  * [Getting testnet coins](payment-for-bitmark-cli.md#getting-testnet-coins)
* [Paying for the Transaction](payment-for-bitmark-cli.md#paying-for-the-transaction)

## [Using Bitmark shares](using-bitmark-shares.md)
  
* [The Basics of CLI commands](using-bitmark-shares.md#the-basic-of-cli-commands)
* [Prerequisites](using-bitmark-shares.md#prerequisites)
* [Creating Bitmark shares](using-bitmark-shares.md#creating-bitmark-shares)
  * [Creating Bitmark shares from a Bitmark Certificate](using-bitmark-shares.md#creating-bitmark-shares-from-a-bitmark-certificate)
  * [Paying for a share creation](using-bitmark-shares.md#paying-for-a-share-creation)
  * [Verifying a share creation transaction](using-bitmark-shares.md#verifying-a-share-creation-transaction)
  * [Verifying the share creation results](using-bitmark-shares.md#verifying-the-share-creation-results)
* [Granting Bitmark shares to another account](using-bitmark-shares.md#granting-bitmark-shares-to-another-account)
  * [Initializing a share grant](using-bitmark-shares.md#initializing-a-share-grant)
  * [Countersigning a share grant](using-bitmark-shares.md#countersigning-a-share-grant)
  * [Paying for a share grant](using-bitmark-shares.md#paying-for-a-share-grant)
  * [Verifying a share grant](using-bitmark-shares.md#verifying-a-share-grant)
* [Swapping Bitmark shares](using-bitmark-shares.md#swapping-bitmark-shares)
  * [Initializing a share swap](using-bitmark-shares.md#initializing-a-share-swap)
  * [Countersigning a share swap](using-bitmark-shares.md#countersigning-a-share-swap)
  * [Paying for a share swap](using-bitmark-shares.md#paying-for-a-share-swap)
  * [Verifying a share swap](using-bitmark-shares.md#verifying-a-share-swap)