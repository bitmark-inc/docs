# Blockchain

## Block

Block is a bunch of transactions that have been added to blockchain. A bitmark block contains data as follows:

| size (bytes) | data                                                           |
|--------------+----------------------------------------------------------------|
|            2 | block version number                                           |
|            2 | transaction count                                              |
|            8 | block number                                                   |
|           32 | argon2 hash of previous block header                           |
|           32 | sha3 hash of all transactions in the block                     |
|            8 | timestamp of block generation time, since 1970-01-01T00:00 UTC |
|            8 | current target difficulty in compact mode                      |
|            8 | number to make hash meets difficulty                           |
|       to end | transactions                                                   |

### Block Verification

When a block is received, following checkings will be made:

1. Length of all parts should match
1. Incoming block version number should be equal or largen than current block version number
1. Incoming block height is 1 ahead of current block height
1. At least 1 transaction, at most 9999 transactions inside a block
1. Incoming block generation time no further than 5 minutes after received time
1. Incoming block generation time can not be larger then 10 minutes compares to current block generation time
1. Incoming block generation time within specific range
1. Incoming block difficulty is same as current difficulty
1. Incoming block hash meets difficulty criteria
1. Incoming block's previous block hash same as current block hash
1. Incoming transaction fits each type's format and length
1. Incoming transaction owner ownership is valid
1. Incoming transaction payment is valid
1. Incoming block's sha3 of all transactions is valid

### Block Synchronization
