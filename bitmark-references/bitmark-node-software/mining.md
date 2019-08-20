# Overview

This paragraph describes how mining works, how mining program communicates with `bitmarkd`, what kind of protocl it uses, and what mechanism is miner rewarded.

# Block Diagram

            +--------------+  zero mq protocal   +---------------+
            |              |  ---------------->  |               |
            |   bitmarkd   |                     |   recorderd   |
            |              |  <----------------  |               |
            +--------------+  zero mq protocal   +---------------+

The hashing procedure relates to `bitmarkd` and `recorderd`. `recorderd` is the program to perform hashing, it receives messages from `bitmarkd` and tries to find hashes possibly meets hashing criteria, if any possible hash is found, `recorderd` sends message back to `bitmarkd` to ask for validation.

When `bitmarkd` receives hash from `recorderd`, `bitmarkd` validates hashing task returned is valid (which means the task is sent from this `bitmarkd` node but not other `bitmarkd` node), the hash is valid. After validating hash correctness, `bitmarkd` sends result bask to `recorderd`.

If `bitmarkd` receives no valid hashes from other nodes or from `recorderd`, `bitmarkd` sends hashing task to `recorderd` every 1 minute until valid hash is received.

## Hashing

Hashing is a behavior to convert any form of data into a unique string of text, if a hashing algorithm is well designed, it should be hard to guess original data from generated hash.

The hashing algorithm used in bitmark is `argon2`, which is a memory hard algorithm that can resist from GPU or ASIC hardware computation. Length of a hash is 256 bit (32 bytes).

Many parameters relates to hashing, if `argon2` executable is installed, following command line can demonstrate the hasing process:

```
printf '%s' 'hello world' | argon2 'hello world' -d -l 32 -m 17 -t 4 -p 1 -r | awk '{for(i=length($1);i>0;i-=2)x=x substr($1,i-1,2);print x}'

f8a17bc25cb53e848e2d09811ade4b8a037f628443661b88611faf5d9a5a1f33
```

A block hash comes from following data:

1. block record version

    blockchain header version

1. transacion count

    number of transactions in the block

1. merkle root

    the hash of all transaction hashes inside the block

1. timestamp

    block generated time

1. difficulty

    hashing difficulty

1. nonce

    random string to make hash fits difficuty

## Difficulty

Difficulty is a way to decide which hash is valid, higher difficulty means harder to find a valid hash.

difficulty is stored in floating point d range from 0 ≤ d < 1, actual difficuty value is 1/d. Difficulty value is encoded as a 57 bit mantissa, normalised to most significant bit to be 1 and can be dropped leaving 56 bits to store:

    [56 bits] [8 bits] = 64 bits unsigned value
    mantissa  exponent

mantissa is right shifted by exponent +8 from most siginificat bit.

Examples:
the "One" value:                00 ff  ff ff  ff ff  ff ff
represents the 256 bit value:   00ff ffff ffff ffff 8000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
value:                          01 ff  ff ff  ff ff  ff ff
represents the 256 bit value:   007f ffff ffff ffff c000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000
