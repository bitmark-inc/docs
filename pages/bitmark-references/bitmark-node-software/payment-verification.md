---
title: Payment Verification
keywords: payment, payment verification
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-node-software/payment-verification
folder: bitmark-references/bitmark-node-software
---

# Payment Verification

This section introduces:

* What the Bitmark payment flow looks like
* How `bitmarkd` validates a transaction that requires a payment from the Bitcoin or Litecoin blockchain

## Overview

When a user submits a new transaction to the Bitmark blockchain via RPC, `bitmarkd` will process it and return transaction details that include payment information.

Someone then needs to pay for the Bitmark transaction using either the Bitcoin or Litecoin blockchain, in accordance with the payment information. This transaction must include the payment id returned by `bitmarkd` as part of the cryptocurrency transaction's `OP_RETURN` opcode.

Once the Bitmark blockchain detects a payment transaction from either blockchain, it marks the target Bitmark transaction as verified and waits for miners to put it into a block.

## Reservoir Module

Reservoir is the module that is used for validating and storing transactions.

### Processing a new transaction

When a new transaction is submitted to the Bitmark blockchain by RPC, it will be processed either by `StoreIssues` or `StoreTransfer`, according to the type of the transaction. This processing checks for the existence of the transaction and also generates a payment id.

### Generating a payment id

The `StoreIssues` function packs issue records as binary data. This packed data is concatenated together and hashed by the SHA3 algorithm. The result of that hashing becomes the payment id. `StoreTransfer` works in the same way for transfer records; the only difference is that there will only be one transaction record in a transfer request.

### Changing the state of a paid transaction

When `bitmarkd` detects a payment transaction from either blockchain, it invokes the function `SetTransferVerified` from Reservoir. The target Bitmark transaction is marked as verified and made available for miners to put it into a block.

### Pending and Verified Structures

The following structures manage all of the payment-related transaction states in `bitmarkd`. They assist `bitmarkd` in validating payments for transactions.

**Pending Structures.** When a transaction initially comes in, Reservoir checks it and saves it into pending structures. If it is a valid new transaction, it will be saved in `pendingIndex` with its transaction id as a key. Reservoir will also add another record with its payment id as key, based on the type of transaction.

```go
pendingTransactions map[pay.PayId]*transactionPaymentData
pendingFreeIssues   map[pay.PayId]*issueFreeData
pendingPaidIssues   map[pay.PayId]*issuePaymentData
pendingIndex        map[merkle.Digest]pay.PayId
```

**Verified Structures.** Once the Bitmark blockchain detects a payment transaction from the Bitcoin or Litecoin blockchain, pending transactions are be moved to verified structures.

```go
verifiedTransactions map[pay.PayId]*transactionData
verifiedFreeIssues   map[pay.PayId]*issueFreeData
verifiedPaidIssues   map[pay.PayId]*issuePaymentData
verifiedIndex        map[merkle.Digest]pay.PayId
```

Verified transactions are collected periodically to form a block foundation. The block data is broadcast to a `recorderd` so that a block can be generated.

## Payment Module

The payment module defines how `bitmarkd` handles payment transactions from the Bitcoin and Litecoin blockchains. When the payment module is initialized, a background process is launched to check blockchain transactions using a mechanism defined in the configuration file.

There are three mechanisms that can be used to allow `bitmarkd` to validate payments for transactions.

1. Using RPC APIs
1. Using Discovery Service
1. Using Bitcoin peer-to-peer protocol (WIP)

### Using RPC APIs

The Bitcoin and Litecoin daemons provide RPC APIs that can be used to invoke and query transactions on those blockchains. This is the simplest way to monitor transactions from the Bitcoin and Litecoin blockchains. Using this method, `bitmarkd` will check the block header for the cryptocurrency blockchains periodically. When a block reaches certain confirmation, `bitmarkd` will pull the block data and scan all transactions in it. If a transaction contains an `OP_RETURN` starting with `6a30`, it will be treated as a potential payment transaction and sent to Reservoir for pending transaction validation.

The main drawback of this method is that Bitmark node runners will need to host a full node for both the Bitcoin and Litecoin blockchains. This consumes both computational power and storage because it requires recording of each blockchain's block data and validation of the healthiness of both chains.

### Using Discovery Service

Discovery is an open-source service that is built on top of blockchain nodes. It watches and extracts all potential payment transactions from both the Bitcoin and Litecoin blockchains simultaneously. It also provides an abstract interface using the ZeroMQ PUBSUB pattern, so that `bitmarkd` can listen to only related transaction, without traversal of whole blocks.

### Using Bitcoin peer-to-peer protocol (WIP)

Bitcoin P2P protocol is the mechanism that Bitcoin daemons use to communicate with each other on the network. By using this protocol, `bitmarkd` doesn't need to rely on specific centralized nodes. instead, the validation process is decentralised. With lessons learned from the SPV client, Bitmark only keeps block headers for blockchains. All detected payment transactions are then sent to Reservoir by the function `SetTransferVerified`. This dramatically reduces storage costs compared to hosting a full node for Bitcoin and Litecoin.
