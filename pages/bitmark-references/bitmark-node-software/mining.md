---
title: Mining
keywords: mining
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-node-software/mining
folder: bitmark-references/bitmark-node-software
---

# Bitmark Mining

## Overview

Mining on the Bitmark blockchain requires an understanding of hashing and difficulty, as well as the communication, verification, and reward protocols.

## Block Diagram

            +--------------+  zero mq protocol   +---------------+
            |              |  ---------------->  |               |
            |   bitmarkd   |                     |   recorderd   |
            |              |  <----------------  |               |
            +--------------+  zero mq protocol   +---------------+

The mining procedure for Bitmark occurs through interactions between `bitmarkd` and `recorderd`. The hashing procedure relates to `bitmarkd` and `recorderd` only. The `recorderd` is a program that performs hashing, it receives jobs from `bitmarkd` and tries to find possible hashes that meets a certain criteria, if a hash is found, the `recorderd` sends a message back to `bitmarkd` and requests a validation.

When `bitmarkd` receives this message from `recorderd`, the `bitmarkd` validates the hash from this special message and returns the result to the `recorderd`.

If `bitmarkd` receives no valid hashes from other nodes or from `recorderd`, then the `bitmarkd` will periodically send hash tasks to `recorderd` (currently every 1 minute), until a valid hash is found or received.

## Hashing

Hashing is the transformation of a string of characters into an unique value or key that represents the original string. There are different hash implementations with a wide range of algorithm, if the hash implementation is well designed, it turns to be very difficult to guess what is the original data from a given hash value.

At bitmark we use `argon2` to compute the hashing, the `argon2` has some benefits such as a memory hard algorithm that provides resistance against GPU and ASIC hardware for computation as well as it provides a hash of 256 bits long.

The `argon2` user-land software provides a wide range of parameters, here there is an example:

```
printf '%s' 'hello world' | argon2 'hello world' -d -l 32 -m 17 -t 4 -p 1 -r | awk '{for(i=length($1);i>0;i-=2)x=x substr($1,i-1,2);print x}'

f8a17bc25cb53e848e2d09811ade4b8a037f628443661b88611faf5d9a5a1f33
```

The hash of a block is made from following information, hashes through `argon2` algorithm:

1. block record version

    blockchain header version

1. transaction count

    number of transactions in the block

1. merkle tree

    A binary tree where the leaves are hashes of transactions; there is an allowable limit of 9999 transaction hashes maximum per block, with random transactions selected if the number of verified transactions exceeds that value.

1. timestamp

    block generated time

1. difficulty

    hashing difficulty

1. nonce

    random string to make the hash fits the difficuty

## Difficulty

Difficulty is decided by blockchain consensus rules, higher difficulty means harder to find a valid hash, when a hash meets difficulty, it means the hash value is less than or equal to the difficulty level. Usually the difficulty level is represented by a number.

For example, when difficulty is 2, it means the hash of a block should contains at least 10 (8+2) leading zeros, so if a block hash is "012345678901234567890123456789012" does not meet criteria of this difficulty because only one leading zero. If another block hash is "00000000001234567890123456789012", then it meets difficulty criteria because it contains 10 leading zeros.

The hash is considered as a fixed 256 bits value and it is composed by two parts:

    [8 bits] [248 bits]
    exponent mantissa

Difficulty value is encoded by 64 bits, including 8 bits of exponent and 56 bits of mantissa.

    [56 bits] [8 bits]
    mantissa  exponent = 64 bits unsigned value

The mantissa bits are normalized, the most significant bit is 1 and can be dropped, leaving the 56 bits to store; these bits are right shifted by exponent +8 from the most significant bit.

The difficulty `One` is defined as `00 ff  ff ff  ff ff  ff ff`, represents 256 bits value `0ff ffff ffff ffff 8000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000`.

The `Two` is the double of difficulty `One`: `01ffffffffffffff`, represents 256 bits value `007fffffffffffffc00000000000000000000000000000000000000000000000`.

## Communication

The `bitmarkd` sends hashing job to `recorderd`. Each `bitmarkd` has a job queue to keep the records of what job has been sent to `recorderd`. If `recorderd` finds a possible hash that might fits the difficulty, it sends the result back to `bitmarkd`, and `bitmarkd` returns the result verified back to `recorderd`.

Here is the message format send from `recorderd` to `bitmarkd`:

1. request

    a string "block.nonce" to represent the type of request

1. job

    `bitmarkd` provides the job's number in the queue

1. packed

    nonce that may makes hash meets difficulty

Here is the message format send from `bitmarkd` to `recorderd`:

1. job

    job number

1. ok

    a string value of "true" and "false", it is used to denote hash is valid or not

For example, if `recorderd` receives a message of `job:2479 ok:false`, it means job number 2479 doesn't meet difficulty criteria. If `recorderd` receives a message of ``job:3000 ok:true`, it means job number 3000 meets difficulty criteria.

## Block Verification and Broadcast

`bitmarkd` receives blocks from other nodes or from `recorderd`, every received block needs to pass following verifications:

1. block hash meets difficulty
1. block header information is same as block data
1. block header correct information of previous block hash
1. payment information is valid
1. compare to local block number, incoming block number is incremented by 1

`bitmarkd` discards incoming block if any of verification fails, the block that passes verifications is stored in the `bitmarkd` and broadcast to all connected nodes.

## Reward

Miner account is stored inside every block. In bitmark, the reward is not given to miner when the block is mined, the reward is given to miner when transaction in miner's block is transferred. The miner is rewarded 0.001 LTC for every transfer of digital asset, which means if a miner mines a block with popular digital asset, the miner gets more rewards.

For example, miner A mines a block number of 1000, and this block contains a digital asset ownership. After some period of time, owner of the digital asset transfers this ownership to another account, once the transaction has be put into blockchain, miner A receives mining fee of 0.001 LTC. If the new owner of that digital asset transfer again, then miner A is rewarded additional 0.001 LTC.
