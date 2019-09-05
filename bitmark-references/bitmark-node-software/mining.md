# Overview

This paragraph describes mining mechanism, including hashing, communication protocol, and rewards.

# Block Diagram

            +--------------+  zero mq protocol   +---------------+
            |              |  ---------------->  |               |
            |   bitmarkd   |                     |   recorderd   |
            |              |  <----------------  |               |
            +--------------+  zero mq protocol   +---------------+

The hashing procedure relates to `bitmarkd` and `recorderd` only. `recorderd` is program to perform hashing, it receives jobs from `bitmarkd` and tries to find hashes possibly meets hashing criteria, if any possible hash is found, `recorderd` sends message back to `bitmarkd` to ask for validation.

When `bitmarkd` receives special string from `recorderd`, `bitmarkd` validates hashes from this special string and returns validation result to `recorderd`.

If `bitmarkd` receives no valid hashes from other nodes or from `recorderd`, `bitmarkd` sends hashing task to `recorderd` periodically (currently every 1 minute), until valid hash is found or received.

## Hashing

Hashing is a behavior to convert any form of data into a unique string of text, if a hashing algorithm is well designed, it should be hard to guess original data from generated output.

Hashing algorithm used in bitmark is `argon2`, which is a memory hard algorithm that can resist from GPU or ASIC hardware computation. Length of a hash is 256 bits long.

Many parameters relates to hashing, if `argon2` executable is installed, following command line can demonstrate the hasing process:

```
printf '%s' 'hello world' | argon2 'hello world' -d -l 32 -m 17 -t 4 -p 1 -r | awk '{for(i=length($1);i>0;i-=2)x=x substr($1,i-1,2);print x}'

f8a17bc25cb53e848e2d09811ade4b8a037f628443661b88611faf5d9a5a1f33
```

A block hash contains following data:

1. block record version

    blockchain header version

1. transacion count

    number of transactions in the block

1. merkle root

    the hash of all transaction hashes inside the block, if verified transactions are less than block allowable limit (9999), then all verified transactions will be put into a block. If verified transactions above block allowable limit, random transactions will be selected

1. timestamp

    block generated time

1. difficulty

    hashing difficulty

1. nonce

    random string to make hash fits difficuty

## Difficulty

Difficulty is a number to decide which hash is valid, higher difficulty means harder to find a valid hash. A hash meets difficulty means hash vaue is less than or equal to difficulty value.

The hash is considered as a 256 bit fixed point value composeda as following two parts:

    [8 bits] [248 bits]
    exponent mantissa

Difficulty value is encoded by 64 bits, including 8 bits of exponent and 56 bits of mantissa.

    [56 bits] [8 bits]
    mantissa  exponent = 64 bits unsigned value

Mantissa is normalized so that most significat bits is one and can be droppped leaving 56 bits to store, itt is right shifted by exponent +8 from the most significant bit.

The difficulty `One` is defined as `00 ff  ff ff  ff ff  ff ff`, represents 256 bits value `0ff ffff ffff ffff 8000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000`.

The `Two` is doubled of difficulty `One`: `01ffffffffffffff`, represents 256 bits value `007fffffffffffffc00000000000000000000000000000000000000000000000`.

## Communication

`bitmarkd` sends hashing job to `recorderd`. Each `bitmarkd` posses a job queue to keep records of what job has been sent to `recorderd`. If `recorderd` finds possible hash that might fits difficulty, it sends result back to `bitmarkd`, and `bitmarkd` returns verified result back to `recorderd`.

The message format from `recorderd` to `bitmarkd` as follows:

1. request

    a string "block.nonce" to represent what kind of request

1. job

    `bitmarkd` provided number to denote job in queue

1. packed

    nonce that may makes hash meets difficulty

The message from `bitmarkd` to reply `recorderd` as follows:

1. job

    job number

2. ok

    denote hash is valid or not

## Block Verification and Broadcast

If a hash is valid, then `bitmarkd` stores that block locally. While sotring block, it will check block data again, including correctness of hash, chain is linked to previous one, payment informatino is valid, etc. After block is successfully stored, `bitmarkd` will broadcast block information to all connected nodes.

When a node recieves block message from other node, it will verify received block by itself, including correctness of hash, owner, payment, etc. As a block is verified, node will store that block and broadcast out to all nodes connected. A newly generated block is propagate in this way to whole network.

## Reward

Every block preserves miner data to denote which account mines (owns) the block, and each block contains some number of transactions. Miner is rewarded fix amount of fee (0.001 LTC) when transaction inside miner mined block has transferred, so for the asset that has more transfer, more mining fee is rewarded to miner.

For example, miner A mines a block which block number is 1000, and this block contains an ownership of specific asset. After some period of time, owner of the asset transfer to another user C, once the transaction has be recorded, miner A receives mining fee of 0.001 LTC.
