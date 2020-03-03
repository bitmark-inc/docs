---
title: Blockchain Security
keywords: security
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-node-software/security
folder: bitmark-references/bitmark-node-software
---

# Blockchain Security

The Bitmark blockchain uses digital signatures and cryptographic
hashes to secure its transactions and blocks.

## Transactions

Individual transactions are secured by cryptographic
signatures. Single signatures are used for basic transactions, while
countersigned signatures are used for special transfers.

The data in a transaction is packed in a specific order, depending on
the transaction type.  An Ed25519 signature is performed over all data
in the packed transaction and appended to form the submission to the
block chain.

In the case of a countersigned transaction, the signature is performed
over the packed transaction *including* the first signature to form
the complete transaction.  While this does make the signatures order
sensitive, it also mean that the receiver of the transfer can verify
the sender before signing.

Details of the Ed25519 signature algorithm can be viewed at: https://ed25519.cr.yp.to/

The important features of Ed25519 for the Bitmark blockchain are:
* high-security signatures with collision resistance
* small 32-byte keys
* small 64-byte signature
* fast verification

## Transaction Identifiers

Transactions are securely incorporated into a block through the
SHA3-256 algorithm, which is used to derive a 32-byte identifier for
each transaction.  This secure hash is performed over all bytes,
including the signatures of the packed transaction. The reason for signing over the signature bytes is to protect against
signature substitution.

SHA3 is a NIST
standard and is the replacement for the old SHA2 algorithm.
The SHA3 algorithm is used because it is faster and also
has protection against a length extension attack that can be
performed against SHA2.

For more details on SHA3: https://en.wikipedia.org/wiki/SHA-3

These Transaction Identifiers are merged into a single root hash using
the Merkle Tree Algorithm: https://brilliant.org/wiki/merkle-tree/

Since the Merkle Tree root hash is sensitive to missing or changed
hashes, and also to the order of the hashes in the tree, it can be used
to minimize the amount of data that is stored in the block header in order to
secure the transactions.  

The Bitmark blockchain uses SHA3-256 for the
Merkle Tree generation so that the result of the Merkle Tree
calculation only requires the storage of a single 32-byte value
in the block header, as opposed to an ordered list of every transaction
identifier in the block.  It also reduces the amount of data that has to be
read to calculate the block hash and the amount of disk storage used for
storing the blocks.

## Block Identifiers

The Argon2 algorithm creates security for the blocks themselves,
though the Block Identifiers.

Block Identifiers are used both to link the previous block and as the
Proof of Work for the blockchain.  Since SHA3 is a fast algorithm
that can be performed on minimal hardware, the Block Identifiers needed to use a
memory-hard algorithm in order to prevent the use of
ASIC miners, while the memory parameters needed to be set to make GPUs uneconomic,
leaving CPUs as the best way to perform the Proof of Work. This
prevents existing owners of Bitcoin and Litecoin mining hardware from
using their large mining systems to disrupt the Bitmark blockchain.

To accomplish these goals, Argon2 was chosen as a modern high-security, memory-hard hashing
algorithm from: https://github.com/P-H-C/phc-winner-argon2

The Block Header is made from the Argon2 hash of the previous block,
the root Merkle hash covering all transactions, and the number of the
block.  Other fields include timestamp, difficulty, and nonce.  The
difficulty is scaled differently from Bitcoin and allows for much
lower hashing rates; while a modern CPU can run SHA2/SHA3 at many
thousands of hashes per second, it can only perform one or two Argon2
hashes per second because of the increase complexity of the algorithm.
The nonce is used by the hashing program to adjust the header to find a hash that
meets the difficulty.

## Proof of Work and Difficulty

As the network changes, the hashing power will change as well, so the
difficulty value is adjusted proportionally. This ensures that
over the long term there is a constant rate of block generated.
