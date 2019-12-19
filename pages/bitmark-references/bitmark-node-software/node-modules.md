---
title: Storage Databases
keywords: node modules, storage
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-node-software/storage
folder: bitmark-references/bitmark-node-software
---

# Storage Databases

The `bitmarkd` program uses [LevelDB](https://github.com/google/leveldb) as its storage backend. LevelDB is a fast key-value storage that doesn't have the concept of logical tables found in traditional relational databases; instead, it partitions the key space by adding a prefix byte to each key. The key-value pairs with the same prefix correspond to a pool of data entries with the same attributes. The values to be stored are compactly serialized to reduce disk usage.

There are two separate LevelDB databases under the data directory of `bitmarkd`: blocks DB and index DB.

## Blocks DB

*The blocks DB* keeps the raw block data.

| pool name | prefix | key | value |
|-----------|--------|-----|-------|
| Blocks            | B | block number              | block data
| BlockHeaderHash   | 2 | block number              | block hash
| BlockOwnerPayment | H | block number              | acceptable cryptocurrencies in this block
| BlockOwnerTxIndex | I | block foundation tx ID    | block number

## Index DB

*The index DB* is built based on the blocks DB, mainly to ensure efficient client queries.

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

The owner-related pools are interrelated. 

## Use Cases

Possible use cases:
- Given account and varying index, one can use `OwnerData[OwnerList[account+index]]` to iterate all bitmarks which belong to this account.
- Given account and tx ID, `OwnerTxIndex[account+txID]` checks if an account owns a bitmark.
