---
title: Security feature of the Bitmark Blockchain
keywords: security
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-node-software/security
folder: bitmark-references/bitmark-node-software
---

# Security feature of the Bitmark Blockchain

The Bitmark Property System uses digital signatures and cryptographic
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
sensitive, it does mean that the receiver of the transfer can verify
the sender before signing.

The Ed25519 signature algorithm details can be viewed at: https://ed25519.cr.yp.to/

The important features for the Bitmark Block chain are:
* high security signatures with collision resistance
* small 32 byte keys
* signature is only 64 bytes
* fast verification

## Transaction Identifiers

Transactions are securely incorporated into a block through the
SHA3-256 algorithm, which is used to derive a 32-byte identifier for
each transaction.  This secure hash is performed over all bytes,
including the signatures of the packed transaction.  This is a NIST
standard and is the replacement for the old SHA2 algorithm.
The SHA3 algorithm is used here because it is fgaster and also
has protection against a length extension attack that can be
performed against SHA2.

For more details: https://en.wikipedia.org/wiki/SHA-3

The reason for signing over the signature bytes is to protect against
signature substitution.

The Transaction Identifiers are merged into a single root hash using
the Merkle Tree Algorithm: https://brilliant.org/wiki/merkle-tree/

Since the Merkle Tree root hash is sensitive to missing or changed
hashes and also to the order of the hashes in the tree it can be used
to minimise the amount of data that is stored in the block header to
secure the transactions.  The Bitmark Blockchain uses SHA3-256 for the
Merkle Tree generation so that the result of the Merkle Tree
calculation is that it is only necessary to store a single 32 byte value
in the block header as opposed to an ordered list of every transaction
identifier in the block.  Also reduces the amount of data that has to be
read to calculate the block hash and the amount of disk storage used for
storing the blocks.

## Block Identifiers

The Argon2 algorithm creates security for the blocks themselves,
though the Block Identifiers.

Block Identifiers are used both to link the previous block and as the
Proof of Work for the block chain.  Since SHA3 is a fast algorithm
that can be performed on minimal hardware it was decided to use a
memory hard algorithm for the Block Identifiers to prevent the use of
ASIC miners and to set the memory parameters to make GPUs uneconomic
leaving CPUs as the best way to perform the Proof of Work.  This
prevents existing owners of Bitcoin and Litecoin mining hardware from
using their large mining systems from disrupting the chain.

So the Argon2 was chosen as a modern high security memory hard hashing
algorithm from: https://github.com/P-H-C/phc-winner-argon2

The Block Header is made from the Argon2 Hash of the previous block,
the root Merkle hash covering all transactions and the number of the
block.  Other fields cover timestamp, difficulty and NONCE.  The
difficulty is scaled differently from Bitcoin and allows for much
lower hashing rates; while a modern CPU can run SHA2/SHA3 at many
thousands of hashes per second, it can only perform one or two Argon2
hashes per second because of the increase complexity of the Algorithm.
The NONCE is used for the hashing program to adjust to find a hash that
meets the difficulty.

## Proof of Work and Difficulty

As the network changes the hashing power will change as well, so the
difficulty value is adjusted proportionally.  This is to ensure that
over the long term there is a constant rate of block generated.
