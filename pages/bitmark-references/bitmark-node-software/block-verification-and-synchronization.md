---
title: Block Validation and Synchronization
keywords: blockchain, verification, sync, synchronization
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-node-software/block-verification-and-synchronization
folder: bitmark-references/bitmark-node-software
---

# Block Validation and Synchronization

# Block Validation and Synchronization

The structure of transactions and block headers is detailed in the [Bitmark Blockchain Technical Overview](bitmark-lockchain-overview.md). What follows are the technical details for how blocks are validated, then synchronized on the Bitmark Blockchain. 

## Block Structure

A block intended for validation on the Bitmark blockchain contains a [block header](bitmark-blockchain-overview.md#block-header) followed by a number of transactions, laid out as follows:

|  size (bytes)   | data                                                                      
| --------------- | ------------------------------------------------------------------------- 
|   2             | block version number                                                      
|   2             | transaction count inside the block                                        
|   8             | block number (block height)                                               
|  32             | Argon2 hash of previous block header                                      
|  32             | SHA-3 hash of all transactions in the block (Merkle root)                  |
|   8             | timestamp of block generation time, seconds since `1970-01-01T00:00:00 UTC` 
|   8             | current difficulty in compact mode                                        
|   8             | number to make hash meets difficulty                                      
|   ... to end    | transactions                                                              



Block Header Example:
```
05008300a1820000000000001e886357e769dab9c5f9b68a9101c13888a8b9aaf2bc21ff3aa2b78fbac114002684b245a1f51f54677770530032471f0ec4c36ffae5f14001eb15f42082e31becc1895d00000000d3dbb256c7042f00deb653d83b4a0bc7
```

Remember that a byte is made up of two hexadecimal characters. The header string could thus be broken up as follows, using the byte counts above:
```
0500/8300/a182000000000000/1e886357e769dab9c5f9b68a9101c13888a8b9aaf2bc21ff3aa2b78fbac11400/2684b245a1f51f54677770530032471f0ec4c36ffae5f14001eb15f42082e31b/ecc1895d00000000/d3dbb256c7042f00/deb653d83b4a0bc7
```

Also remember that each element has its bytes reversed because it is encoded in Little Endian. The various fields are thus decoded as follows:
```
Version:0x5,
TransactionCount:0x83,
Number:0x82a1,
PreviousBlock: 0x0014c1ba8fb7a23aff21bcf2aab9a88838c101918ab6f9c5b9da69e75763881e,
MerkleRoot: 0x1be38220f415eb0140f1e5fa6fc3c40e1f47320053707767541ff5a145b28426,
Timestamp:0x5d89c1ec,
Difficulty:00978263ab596de9800000000000000000000000000000000000000000000000,
Nonce:0xc70b4a3bd853b6de
```
Different types of transactions following the block header will then be different lengths and have different content.

## Block Validation

When a block is received, the following tests are conducted to ensure its validity:

1. Length of all parts inside a block must match.
2. Incoming block version number must be equal or larger than current block version number.
3. Incoming block height must be 1 ahead of current block height.
4. Incoming block must contain at least 1 transaction, at most 9999 transactions.
5. Incoming block generation time must be within 5 minutes compared to received time.
6. Incoming block generation time must be no larger than 10 minutes compared to current block generation time.
7. Incoming block generation time must be within specific range.
8. Incoming block difficulty must be same as current difficulty.
9. Incoming block hash must meet difficulty criteria.
10. Incoming block's previous block hash must be same as current block hash.
11. Incoming transaction must fit each type's format and length.
12. Incoming transaction owner ownership must be valid.
13. Incoming transaction payment must be valid.
14. Incoming block's SHA-3 of all transactions with must be valid.

After a block is validated, a node stores that block into its internal
database (`leveldb`), then the node broadcasts this newly saved block to all connected
nodes. When other nodes receive the broadcast of a block, each node
validates block correctness by the rules described above.

## Block Synchronization

The Bitmark blockchain uses both proof-of-work (PoW) and majority votes to
choose blocks.

### Proof of Work

Proof of work is the traditional method of Sybil defense on a blockchain, used by Bitcoin and (at the moment) by Ethereum. Every participant is given the opportunity to solve a math problem. Whoever manages to do so is allowed to propose a block for the blockchain, contributing to the consensus and the growth of the ledger. Sybil defense is provided by the fact that it’s very hard to make these calculations, and so block creation has real costs in energy.

In order for a block to be accepted by network participants, miners must have completed a proof of work that covers all of the data in the block. The difficulty of this work is adjusted so as to limit the rate at which new blocks can be generated by the network to one every two minutes. Due to the very low probability of successful generation, this makes it unpredictable which miner in the network will be able to generate the next block.

For a block to be valid, it must hash to a value less than the current difficulty; this means that each block indicates that work has been done generating it. Each block contains the hash of the preceding block, thus each block has a chain of blocks that together contain a large amount of work. Changing a block (which can only be done by making a new block containing the same predecessor) requires regenerating all successors and redoing the work they contain. This protects the block chain from tampering.

Bitmark uses [Argon2](https://en.wikipedia.org/wiki/Argon2) to hash the block header; the rest of the data in the block is protected by having the Merkle Tree root hash as part of the header. If transactions are different or in a different order then the Merkle Tree root will not match. and the block will be rejected.

### Majority Votes

When deciding upon the next block, each node considers decisions from other nodes. The block selected by the most other nodes will be chosen. Every 30 seconds, a node asks its connected nodes for their block hash and block height. This information is used to determine the main chain based on majority vote. For different chains, the same block height will have a different block hash, so a node can distinguish a fork by testing the block hash for a specific block number.

A variety of conditions could occurs when nodes are deciding whether to select a block.

1. Majority votes exists

| Node   | Block Height   | Block Hash                                                            | 
| ------ | -------------- | --------------------------------------------------------------------- |
| 1      | 1000           | `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |
| 2      | 1000           | `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |
| 3      | 1000           | `c77a4078350526ca9da34b50e4920558082b7e5c7d8f50b6fb1ecb0e78b44a0d`    |
| 4      | 1000           | `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |
| 5      | 1000           | `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |
| 6      | 1000           | `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |

In this example, node-3 resides on a different chain than the others (because
its block hash is different from others at same block height).

Each node will then query its fellows to determine the majority vote.
Assuming all nodes are connected, node-1, node-2, node-4, node-5, and node-6 will all see the following results when they ask for consensus.

|  Count  |  Block Height  |  Block Hash                                                           |
| ------- | -------------- | --------------------------------------------------------------------- |
|  4      |  1000          | `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |
|  1      |  1000          | `c77a4078350526ca9da34b50e4920558082b7e5c7d8f50b6fb1ecb0e78b44a0d`    |

They will each choose the chain that has hash `abcdefg` on block
height 1000.

Meanwhile, node-3 will see the following results when asking for majority votes:

|  Count  |  Block Height  |  Block Hash                                                           |
| ------- | -------------- | --------------------------------------------------------------------- |
|  5      |  1000          | `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |

It also will choose the chain that has hash `abcdefg` on block height
1000, which means it will sync to the other nodes.

2. Several groups with same votes

|  Node  |  Block Height  |  Block Hash                                                            |
| ------ | -------------- | ---------------------------------------------------------------------- |
|  A     |  1000          |  `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |
|  B     |  1000          |  `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |
|  C     |  1000          |  `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |
|  D     |  1000          |  `c77a4078350526ca9da34b50e4920558082b7e5c7d8f50b6fb1ecb0e78b44a0d`    |
|  E     |  1000          |  `c77a4078350526ca9da34b50e4920558082b7e5c7d8f50b6fb1ecb0e78b44a0d`    |
|  F     |  1000          |  `c77a4078350526ca9da34b50e4920558082b7e5c7d8f50b6fb1ecb0e78b44a0d`    |

In this example, two chains have equal votes. 

|  Count  |  Block Height  |  Block Hash                                                           |
| ------- | -------------- | --------------------------------------------------------------------- |
|  3      |  1000          | `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d`    |
|  3      |  1000          | `c77a4078350526ca9da34b50e4920558082b7e5c7d8f50b6fb1ecb0e78b44a0d`    |

In this case, there's a tie between `58583d17235c2b4e171c003fc96cde12fd52bb4b35658cbe85dd394f52fea08d` and `c77a4078350526ca9da34b50e4920558082b7e5c7d8f50b6fb1ecb0e78b44a0d`, and the chain with the smaller hash value will be chosen. Since block hash is stored in little endian, the value of `c77a4078350526ca9da34b50e4920558082b7e5c7d8f50b6fb1ecb0e78b44a0d` is actually the smaller value, and the chain with that block hash is chosen. This means that `c77a4078350526ca9da34b50e4920558082b7e5c7d8f50b6fb1ecb0e78b44a0d` will eventually win over as the selected chain and dominate the network.

This tie breaking selection could occur when a new node-7 joins the network or when some node notes that all other connected, remote nodes have separated into equal groups.
