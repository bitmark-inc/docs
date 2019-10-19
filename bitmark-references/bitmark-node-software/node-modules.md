---
title: Node Modules
keywords: node modules, storage
last_updated: 
sidebar: mydoc_sidebar
permalink: node-modules.html
folder: bitmark-references/bitmark-node-software
---

## Storage

The bitmarkd program uses [LevelDB](https://github.com/google/leveldb) as the storage backend. LevelDB is a fast key-value storage without the concept of logical tables in traditional relational databases, so we partition the key space by adding a prefix byte to each key. The key-value pairs with the same prefix corresponds to a pool of data entries with the same attributes. The values to be stored are compactly serialized to reduce the disk usage.

There are two separate LevelDB databases under the data directory of bitmarkd:

1. *The blocks DB* keeps the raw block data.

| pool name | prefix | key | value |
|-----------|--------|-----|-------|
| Blocks            | B | block number              | block data
| BlockHeaderHash   | 2 | block number              | block hash
| BlockOwnerPayment | H | block number              | acceptable cryptocurrencies in this block
| BlockOwnerTxIndex | I | block foundation tx ID    | block number

2. *The index DB* is built based on the blocks db, mainly for efficient client queries.

| pool name | prefix | key | value |
|-----------|--------|-----|-------|
| Transactions      | T | tx ID              | the block number in which the tx was recorded + the tx record
| Assets            | A | asset ID           | the block number in which the asset was recorded + the asset record
| OwnerNextCount    | N | account            | next index value for this account in OwnerList
| OwnerList         | L | account + index    | tx ID
| OwnerTxIndex      | D | account + tx ID    | index of the tx in OwnerList
| OwnerData         | p | tx ID              | detailed property info (could be asset, block, or share)
| Shares            | F | share ID           | quantity of total shares + tx ID
| ShareQuantity     | Q | account + share ID | balance of shares for the account

The owner-related pools are interrelated. Possible use cases:

- Given account and varying index, one can use `OwnerData[OwnerList[account+index]]` to iterate all bitmarks which belong to this account.
- Given account and tx ID, `OwnerTxIndex[account+txID]` checks if the account owns the bitmark.
