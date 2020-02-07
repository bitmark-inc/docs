---
title: Working with Bitmark
keywords: bitmark, account, transaction
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/working-with-bitmark
folder: learning-bitmark/quick-start/working-with-bitmarks
---

# Working with Bitmark

## Bitmark Account

Any user interacting with the Bitmark Property System requires a Bitmark Account. It can be created using the [Bitmark App](using-bitmark-app.md#creating-a-bitmark-account), the [SDK](using-sdk.md#creating-a-bitmark-account), or the [CLI](using-cli.md#creating-a-bitmark-account).

After creating an Account, a user will often want to recover the seed (which is the private key that can be used to control the Account) and the recovery phrase (which is a set of 12 mnemonic words that can be used to regenerate the seed).

### Bitmark Account Number

Property owners in Bitmark system are identified by their Ed25519 public keys. These public keys are represented in the Bitmark Property System by Bitmark Account Numbers, which encode the Ed25519 key in based58 format.

*Example — Bitmark Account Number on [Livenet](https://registry.bitmark.com/account/bqSUHTVRYnrUPBEU48riv9UwDmdRnHm9Mf9LWYuYEa7JKtqgKw):*
>       `bqSUHTVRYnrUPBEU48riv9UwDmdRnHm9Mf9LWYuYEa7JKtqgKw`
         
       
*Example — Bitmark Account Number on [Testnet](https://registry.test.bitmark.com/account/fABCJxXc8aYGoj1yLLXmsGdWEo1Y5cZE9Ko5DrHhy4HvgGYMAu/owned):*
>       `fABCJxXc8aYGoj1yLLXmsGdWEo1Y5cZE9Ko5DrHhy4HvgGYMAu`

## Bitmark Certificates

Assets with titles that have been publicly recorded are [more valuable](../../problem-we-are-trying-to-solve.md) than those without. They are what grant basic rights, such as the ability to resell, rent, lend, and donate the property. The Bitmark blockchain allows individuals to access these rights for digital assets by registering their titles as Bitmark Certificates. This can be done using the [Bitmark App](using-bitmark-app.md#registering-bitmark-certificates), the [SDK](using-sdk.md#registering-bitmark-certificates), or the [CLI](using-cli.md#registering-bitmark-certificates).

## Transactions

### Bitmark Certificate registration

The process of registering a Bitmark Certificate for a digital asset occurs in two steps:

* Registering the asset: this creates an *Asset Record*, which is stored on the Bitmark blockchain.

* Issuing bitmarks: this creates *Issue Records* linking to the corresponding asset record, which are also stored on the Bitmark blockchain.

This process registers legal property rights on the public Bitmark blockchain for an individual's digital assets, including personal health and social data, creative works such as art, photography, and music, and other intellectual property. These legal rights determine who owns property and what can be done with it, whether the individual wants to keep it, sell it, or donate it.

### Bitmark Certificate transfer

Once an asset has been registered, the owner can trade it by creating a transfer record that points back to the original issue record (or to a previous transfer record) and that lists the new owner of the asset. Because the blockchain is ordered and because it's immutable, this creates a permanent chain of custody reaching back to the asset's origins.

<div style="background-color: #efefef; text-align: center;">
    <img src="/assets/images/TransferringBitmark_0.png" alt="Record chain" title="Record chain" style="padding: 20px" />
</div>

Bitmark owners can transfer their Bitmark Certificates to others using the [Bitmark App](using-bitmark-app.md#transferring-bitmark-certificates), the [SDK](using-sdk.md#transferring-bitmark-certificates), or the [CLI](using-cli.md#transferring-bitmark-certificates).

## Bitmark shares

In some cases, the ownership of a property is shared between different parties or people. To support these situations, the Bitmark Property System provides a feature called **[Bitmark shares](../.../../bitmark-appendix/bitmark-shares)**.

Any owner of a Bitmark Certificate is able to:

* [Create Bitmark shares](using-bitmark-shares.md#creating-bitmark-shares) from that Bitmark Certificate.
* [Grant Bitmark shares](using-bitmark-shares.md#granting-bitmark-shares-to-another-account) to another account.
* [Swap Bitmark shares](using-bitmark-shares.md#swapping-bitmark-shares) with other accounts.

Three records related to Bitmark shares are stored on the Bitmark blockchain.

* *Balance Record* - created by a bitmark owner to permanently set the total number of a particular share for a Bitmark Certificate.
* *Grant Record* - created by an owner to grant an amount of his share balance to another owner.
* *Swap Record* - created by two owners to simultaenously swap their shares of different Bitmark Certificates.

The transactions related to the Bitmark shares can be done using the CLI as described in [Using Bitmark shares](using-bitmark-shares.md) section.



