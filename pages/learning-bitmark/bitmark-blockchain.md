---
title: Bitmark Blockchain Introduction
keywords: blockchain
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/bitmark-blockchain
folder: learning-bitmark
---

# Bitmark Blockchain Introduction

## Technical Overview

The Bitmark blockchain is the property system for the digital generation. It was built with cutting-edge blockchain technology to match the needs of our borderless and global digital lives and futures.

![Bitmark Blockchain](/assets/images/bitmark_processes_en_2500w.png)

The Bitmark blockchain features some of the same strengths as other blockchains, such as the immutability of an ordered and distributed ledger. However, the Bitmark blockchain is specialized for property transactions and has specific strengths related to that: by uniquely identifying property, encoding its title, and supporting transfers, Bitmark creates clear provenance and chain of ownership for unique digital assets. This decentralized structure empowers individuals by granting them personal control over their assets.

To read more about the Bitmark property system, how it expands on the basic ideas of the blockchain, and how it uses a variety of blockchain records to manage digital property and data, please [read our blog posts here](https://medium.com/clean-titles/defining-property-in-the-digital-environment-part-three-4c3ecbab5833).

For more details, read our Technical FAQ below or our [papers](https://docs.bitmark.com/bitmark-appendix/bitmark-papers).

## Technical FAQ

The following questions and answers are drawn in part from our papers and provide more depth than the overview of the Bitmark property system found in our blog posts.

**The Bitmark Blockchain**
 
* [Why use the Bitmark Blockchain to record property?](#why-use-the-bitmark-blockchain-to-record-property)

* [Why not just use Bitcoin or Ethereum tokens to represent property?](#why-not-just-use-bitcoin-or-ethereum-tokens-to-represent-property)

**Registering Bitmark Certificates**

* [How are property owners identified in the Bitmark Property System?](#how-are-property-owners-identified-in-the-bitmark-property-system)

* [How is property registered in the Bitmark Property System?](#how-is-property-registered-in-the-bitmark-property-system)

* [How are Bitmark miners encouraged to publish issue records?](#how-are-bitmark-miners-encouraged-to-publish-issue-records)

* [How does the Bitmark Blockchain protect property?](#how-does-the-bitmark-blockchain-protect-property)

**Transferring Bitmark Certificates**

* [How is property transferred in the Bitmark Property System?](#how-is-property-transferred-in-the-bitmark-property-system)

* [How are Bitmark miners encouraged to publish transfer records?](#how-are-bitmark-miners-encouraged-to-publish-transfer-records)

### The Bitmark Blockchain

#### Why use the Bitmark Blockchain to record property?

When you own land, means of production, inventions, creative works, or other assets, you also have a title to those assets. A property title is the legal instrument by which an entity claims ownership of an asset. It also serves as a "container" for transferring property rights from one owner to another. To be legally binding, title transfers must be publicly recorded in property systems such as county land registrars or a state departments of motor vehicles.

![Bitmark Ownership](/assets/images/bitmark_ownership_en_2500w.png)

Assets with titles that have been publicly recorded are more valuable than those without. They are what grant basic rights, such as the ability to resell, rent, lend, and donate. The Bitmark Blockchain offers the opportunity to register titles for your digital assets.

#### Why not just use Bitcoin or Ethereum tokens to represent property?

Traditional cryptocurrency tokens can be split and rejoined, which is a bad model for property: you wouldn’t want to cut a painting into six parts, then put it back together! The fungibility of traditional cryptocurrency is also at odds with the need to record provenance for property. Finally, there’s no ability on traditional systems for a recipient to countersign to agree to the transfer of property.

There are methods to get around some of this issues on the Bitcoin blockchain, such as recording information in OP_RETURNS or directly encoding data in UTXOs. Similarly, specific smart contracts could have been created in Ethereum to create non-fungible tokens.

However, we ultimately felt that a network designed specifically for registering property rights could minimize resource requirements and reduce security attack vectors. The question then became “Is registering, tracking, and trading digital property popular enough to warrant a specialized system?” History shows that the answer to that is clearly “yes”; we believe that it’s the most sustainable long-term strategy.

### Registering Bitmark Certificates

#### How are property owners identified in the Bitmark Property System?

Each property owner in the Bitmark Property System is identified by a public key. They must then decide how to store their linked private key. They could choose to do so themselves, possibly using the Bitmark mobile app, or they could store it directly with Bitmark. They can also decide to link their public key to a real-world identity or to remain pseudonymous.

#### How is property registered in the Bitmark Property System?

The Bitmark blockchain records registrations with Bitmark Certificates that can be easily read and verified.

An asset record contains the following information:

* A fingerprint hash of the asset, with options delineated by the Bitmark Trade Service.

* The registrant of the asset, defined by their public key.

* The name of the asset, a short name of 64 UTF-8 characters or less

* Optional metadata, consisting of key-value pairs.

* A signature of a hash of the above fields, using the registrant’s private key.

There can only be one asset record for each digital property on the Bitmark blockchain. It’s only placed on the blockchain when an issue record for the asset is verified and itself placed on the Bitmark blockchain. Later issue records for the same asset will point back to the original asset record.

An issue record contains the following information:

* An assetId, which is a SHA3-512 hash of the asset’s fingerprint.

* A nonce, which numbers this particular issuance of the asset.

* The owner of the asset, defined by their public key.

* A signature of a hash of the above fields, using the registrant’s private key.

There can be multiple issue records for the same property, each defined by a different nonce, and each representing a different instance of the property. Typically, these represent “limited editions” of a digital asset or authorized copies of digital data.

#### How are Bitmark miners encouraged to publish issue records?

Registration of a an asset on the Bitmark Blockchain usually doesn't require a payment; instead, a Hashcash calculation is conducted by the asset owner.

Though a miner isn’t immediately paid for these issuances in his block, he’s still incentivized to mine the issue records because he’s given a Bitmark Certificate on the block. This will reward him when the digital properties in the block are later transferred.

#### How does the Bitmark Blockchain protect property?

A decentralized system such as Bitmark allows almost anyone to issue Bitmark Certificates to just about anything. When legal disputes arise, the immutability of the blockchain allows it to serve as evidence in conflicting ownership claims. This permanent public record of ownership can also help deter bad actors. Encryption can be used to further protect digital assets that have been registered as bitmark certificates.

![Bitmark Blockchain protects Ownership](/assets/images/ownership_blockchain-digital_property_en_2500w.png)

### Transferring Bitmark Certificates

#### How is property transferred in the Bitmark Property System?

Once an asset has been issued, trading it simply requires the owner to create a new transfer record that points back to the original issue record (or to the previous transfer record) and that shows the new owner of the asset. Because the blockchain is ordered and because it’s immutable, this creates a permanent chain of custody, reaching back to the asset’s origins.

![Bitmark signature chain](/assets/images/bitmark_signature_chain_graphic_en_2500w.png)

A transfer record contains the following information:

* A link, which is a SHA3-512 hash of the asset’s previous record, creating the chain of ownership.

* An owner, which is the public key of the recipient of the asset.

* An optional payment, which lists the Bitcoin or Litecoin currency, an amount, and an address.

* A signature of a hash of the above fields, using the previous owner’s private key.

* An optional countersignature using the new owner’s private key.

In order to create a transfer record, the previous owner must pay a small transfer fee. There is no option for instead performing a Hashcash calculation.

#### How are Bitmark miners encouraged to publish transfer records?

Transaction fees are required for transfer records. (They can also be optionally used for issue records.) They incentivize the miners to include records in their blocks. Because there is no cryptocurrency on the Bitmark blockchain itself, these fees are managed through interactions with cryptocurrency blockchains.

Whereas most blockchains have a single, verified mempool, Bitmark has two mempools: a pending mempool and a verified mempool. After a Bitmark transaction is created and its signature and link are checked, it’s placed in the pending mempool. It will stay there for up to an hour or until its fee is paid.

The placement of a record in the pending mempool marks the beginning of a five-step process where the Bitmark blockchain requests transaction fees and eventually sends them to miners (called “recorders” on the Bitmark blockchain):

1. After creating a transaction, the creator receives a payment request, which includes both a payment ID and a list of possible currencies (currently BTC Bitcoin and LTC Litecoin) and payment addresses.

2. The record creator pays the fee on one of those other blockchains and includes the payment ID in the payment transaction’s OP_RETURN. This fee should be 0.0002 BTC or 0.002 LTC

3. Bitmark watches those other blockchains; when it spots a payment it moves the associated Bitmark transaction from the pending mempool to the verified mempool, making it available for mining.

4. When a miner successfully mines a block, he includes his own payment addresses for all possible currencies.

5. Bitmark pays fees from the block to the miner at his linked addresses.

Even though the Bitmark blockchain doesn’t transact currencies, it is able to leverage the advantages of cryptocurrencies by these links to other blockchains.
