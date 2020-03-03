---
title: Block Mining
keywords: mining
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-node-software/bitmark-mining
folder: bitmark-references/bitmark-node-software
---

# Block Mining

Mining on the Bitmark blockchain requires an understanding of hashing and difficulty, as well as of the communication, verification, and reward protocols.

## Block Diagram

            +--------------+  ZeroMQ protocol   +---------------+
            |              |  --------------->  |               |
            |   bitmarkd   |                    |   recorderd   |
            |              |  <---------------  |               |
            +--------------+  ZeroMQ protocol   +---------------+

The mining procedure for Bitmark occurs through interactions between `bitmarkd` and `recorderd`: 
1. `bitmarkd` sends a job to `recorderd`, requesting a hash that meets certain criteria.
2. `recorderd` tries to find possible hashes that meets those criteria.
3. If a hash is found, `recorderd` sends a message back to `bitmarkd` and requests a validation.
4. When `bitmarkd` receives this message from `recorderd`, it validates the hash and returns the result to `recorderd`.
5. If `bitmarkd` receives no valid hashes from other nodes or from `recorderd`, then it will periodically send hash tasks to `recorderd` (currently every 1 minute), until a valid hash is found or received.

## Hashing

Hashing is the transformation of a string of characters into an unique value or key that represents the original string. There are different hash implementations using a wide range of algorithms; if the hash implementation is well designed, it is very difficult to guess the original data from a given hash value.

The Bitmark blockchain uses `argon2` to compute its hashing; `argon2` has some benefits, such as a memory-hard algorithm that provides resistance against GPU and ASIC hardware computation and the production of a hash that is 256 bits long.

The `argon2` user-land software supports a wide range of parameters. 

Example:
```shell
$ printf '%s' 'hello world' | argon2 'hello world' -d -l 32 -m 17 -t 4 -p 1 -r | awk '{for(i=length($1);i>0;i-=2)x=x substr($1,i-1,2);print x}'

f8a17bc25cb53e848e2d09811ade4b8a037f628443661b88611faf5d9a5a1f33
```

The hash of a block is made from the following information, hashed through the `argon2` algorithm:

1. Block record version

    blockchain header version

2. Transaction count

    number of transactions in the block

3. Merkle tree

    A binary tree where the leaves are hashes of transactions; there is an allowable limit of 9999 transaction hashes maximum per block, with random transactions selected if the number of verified transactions exceeds that value.

4. Timestamp

    block generated time

5. Difficulty

    hashing difficulty

6. Nonce

    random string to make the hash fit the difficulty

## Difficulty

As described in the [Bitmark Blockchain Technical Overview](bitmark-blockchain-overview.md#block-hashing-argon2-difficulty-proof-of-work-), difficulty is decided by blockchain consensus rules. A higher difficulty means that it is harder for a miner to find a valid hash; when a hash meets a difficulty, that means that the hash value is less than or equal to the difficulty level. Usually, the difficulty level is represented by a number.

For example, when difficulty is 2, the hash of a block should contains at least 10 (8+2) leading zeros. A block hash of "012345678901234567890123456789012" would not meet this difficulty criteria because it only has one leading zero, but a block hash of "00000000001234567890123456789012" would because it contains 10 leading zeros.

The hash is a fixed 256-bit value that is composed of two parts:

    [8 bits] [248 bits]
    [exponent] [mantissa]

Difficulty value is encoded in 64 bits, including 8 bits of exponent and 56 bits of mantissa.

    [56 bits] [8 bits]
    [mantissa]  [exponent] = 64 bits unsigned value

The mantissa bits are normalized: the most significant bit is 1 and can be dropped, leaving 56 bits to store; these bits are right shifted by exponent +8 from the most significant bit.

The difficulty `One` is defined as `00 ff  ff ff  ff ff  ff ff`, represents the 256-bit value `0ff ffff ffff ffff 8000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000`.

The difficulty `Two` is  double the difficulty of `One`: `01ffffffffffffff`, which represents 256-bit value `007fffffffffffffc00000000000000000000000000000000000000000000000`.

## Communication

`bitmarkd` sends a hashing job to `recorderd`. Each `bitmarkd` has a job queue that lists the records of what job have been sent to `recorderd`. If `recorderd` finds a possible hash that might fits the difficulty, it sends the result back to `bitmarkd`, and `bitmarkd` returns the validated result  to `recorderd`.

The following message format is used to send from `recorderd` to `bitmarkd`:

1. request

    a string `block.nonce` to represent the type of request

2. job

   the job's number in the queue, provided by `bitmarkd`

3. packed

    a nonce that may make hash meet difficulty

The following message format is used to send from  `bitmarkd` to `recorderd`:

4. job

    job number

5. ok

    a string value of "true" and "false", it is used to denote if hash is valid or not

For example, if `recorderd` receives a message of `job:2479 ok:false`, it means job number 2479 doesn't meet difficulty criteria. If `recorderd` receives a message of `job:3000 ok:true`, it means job number 3000 meets the difficulty criteria.

## Verification and Broadcast

`bitmarkd` receives blocks from other nodes or from `recorderd`; each received block needs to pass the following verifications:

1. block hash must meet difficulty
2. block header information must be same as block data
3. block header must contain correct information of previous block hash
4. payment information must be valid
5. compared to local block number, incoming block number must be incremented by 1

`bitmarkd` discards incoming block if any of verification fails; a block that passes verifications is stored in `bitmarkd` and broadcast to all connected nodes.

## Reward

Miner account information is stored inside each block. However, on the Bitmark blockchain, a mining reward is not given to a miner when the block is mined; instead, the reward is given to a miner when transactions in the miner's block are transferred. The miner is rewarded 0.001 LTC for every transfer of a digital asset, which means if a miner mines a block with popular digital assets, they get more rewards.

For example, miner A mines block number 1000, and this block contains a digital asset. After some period of time, the owner of the digital asset transfers the asset to another account. Once the transfer record has been put into the blockchain, miner A receives a mining fee of 0.001 LTC. If the new owner of that digital asset transfer again, then miner A is rewarded an additional 0.001 LTC.
