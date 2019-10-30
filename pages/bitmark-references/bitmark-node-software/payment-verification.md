---
title: Payment Verification
keywords: payment, payment verification
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-node-software/payment-verification
folder: bitmark-references/bitmark-node-software
---

# Payment Verification

In this section, we will introduce

* How does the payment flow look like
* How does bitmarkd validate a transaction which requires a payment from bitcoin / litecoin blockchain

## Flow

When a user submit a new transaction to the blockchain by RPC, bitmarkd will process it and return a transaction detail that inlcudes payment information.

Someone needs to pay for the bitmark transaction by either bitcoin or litecoin blockchain according to the payment information. In the payment transaction, it must include the payment id by using `OP_RETURN` opcode.

Once bitmark blockchain detects a payment transaction from either blockchain, the target bitmark transaction will be marked as verified and wait for miners to put it into a block.

## Reservoir Module

Reservoir is module that is used to validating and storing transactions.

### Processing a new transaction

When a new transaction is submitted to the blockchain by RPC, it will be processed either by `StoreIssues` or `StoreTransfer` according to the type of the transaction. The processing includes the transaction existence checking as well as generating a payment id which is bound to transactions from this request.

### Generate a payment id

In the `StoreIssues` function, every issue transaction record in the request will be packed into a binary data. These packed data will be concatenated together and be hashed by SHA3 algorithem. The result of that hashing will become the payment id. `StoreTransfer` works in the same way. The only different is that there will be only one transaction record in a transfer request.

### Change the state of a paid transaction

When bitmarkd detects a payment transaction from either blockchain, it will invoke function `SetTransferVerified` from reservoir. The target bitmark transaction will be marked as verified and wait for the miner to put it into a block.

### Structures

In order to maintain all the transaction states in the bitmarkd, we use the following structures to manage all transactions in the bitmarkd.

First, when a transaction comes in, reservoir will check them and save them into pending structures. If it is a valid new transaction, it will be saved in `pendingIndex` with its transaction id as a key. Based on the types of transaction, it will also add another record with its payment id as key. These structures assist bitmarkd validating the payments for transactions.

```go
pendingTransactions map[pay.PayId]*transactionPaymentData
pendingFreeIssues   map[pay.PayId]*issueFreeData
pendingPaidIssues   map[pay.PayId]*issuePaymentData
pendingIndex        map[merkle.Digest]pay.PayId
```

Once the system detect a payment transaction from the bitcoin or litecoin blockchain, those paid pending transactions will be moved to verified structures.

```go
verifiedTransactions map[pay.PayId]*transactionData
verifiedFreeIssues   map[pay.PayId]*issueFreeData
verifiedPaidIssues   map[pay.PayId]*issuePaymentData
verifiedIndex        map[merkle.Digest]pay.PayId
```

Verified transactions will be collected periodically and form a block foundation. The block data will be broadcasted to a recorderd so that a block can be generated.

## Payment Module

Payment module defines how bitmarkd handles payment transactions from bitcoin / litecoin blockchain. When payment module is initialised, a background process will be launched to check blockchain transactions using the mechansim that is set in the configuration file.

### Payment Validation

There are three mechanisms that you can choose for the bitmarkd to validate payments for transactions.

1. Directly RPC
1. Discovery Service
1. Bitcoin peer-to-peer protocol (WIP)

### Directly RPC

Bitcoin / Litecoin daemon provides RPC api for people to invoke and query transactions on it. This is the simplest way to monitoring transactions from the bitcoin blockchain. In this method, bitmarkd will check the block header periodically. When a block reaches certain confirmation, bitmarkd will pull the block data and scan all transactions in it. If a transaction contains an OP_RETURN starts with `6a30`, it will be treated as a potential payment transaction and send to reservoir for validating pending transactions.

There are some drawback for this method. Node runners need to host a full-node for both bitcoin and litecoin blockchain. It will occupy storages and computation power from your because you have to save all block data and validation the healthiness of blockchains.

### Discovery Service

The discovery is another open-sourced service that is built on top of blockchain nodes. It watches and extracts all potential payment transactions from both blockchains simultaneously. It also provides an abstract interface using zeromq PUBSUB pattern so that bitmarkd can only listen to related transaction without traversal the whole blocks.

### Bitcoin peer-to-peer protocol (WIP)

Bitcoin P2P protocol is the mechansim that bitcoin daemons communicate to each other in the network. By using this protocol, bitmarkd don't really need to rely on certain centralized nodes. It makes the validation process be decentralised. Learning from the SPV client, we only keep block headers for blockchains. For all detected payment transaction, it will send to reservoir by function `SetTransferVerified`. Therefore, it reduces huge storage cost comparing to host a full-node for bitcoin and litecoin.
