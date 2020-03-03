
# Bitmark Node Software


## [Bitmark Blockchain Technical Overview](bitmark-blockchain-overview.md)

* [Definitions](bitmark-blockchain-overview.md#definitions)
* [Transactions: Asset, Issue and Transfer Records](bitmark-blockchain-overview.md#transactions-asset-issue-and-transfer-records)
    * [Asset Record](bitmark-blockchain-overview.md#asset-record)
    * [Issue Record](bitmark-blockchain-overview.md#issue-record)
    * [Transfer Record](bitmark-blockchain-overview.md#transfer-record)
* [Transactions: Share](bitmark-blockchain-overview.md#transactions-share)
  * [Share Balance Record](bitmark-blockchain-overview.md#share-balance-record)
  * [Share Grant Record](bitmark-blockchain-overview.md#share-grant-record)
  * [Share Swap Record](bitmark-blockchain-overview.md#share-swap-record)
* [Transactions: Block ownership record](bitmark-blockchain-overview.md#transactions-block-ownership-record)
  * [Block Foundation Record](bitmark-blockchain-overview.md#block-foundation-record)
  * [Block Owner Transfer Record](bitmark-blockchain-overview.md#block-owner-transfer-record)
* [Blockchain Structure](bitmark-blockchain-overview.md#blockchain-structure)
  * [Block Header](bitmark-blockchain-overview.md#block-header)
  * [Merkle Tree](bitmark-blockchain-overview.md#merkle-tree)
  * [Block Hashing (Argon2, difficulty, proof of work \.\.\.)](bitmark-blockchain-overview.md#block-hashing-argon2-difficulty-proof-of-work-)
  
## [Block Validation and Synchronization](block-verification-and-synchronization.md#block-verification-and-synchronization)

* [Block Structure](block-verification-and-synchronization.md#block-structure)
* [Block Validation](block-verification-and-synchronization.md#block-validation)
* [Block Synchronization](block-verification-and-synchronization.md#block-synchronization)
  * [Proof of Work](block-verification-and-synchronization.md#proof-of-work)
  * [Majority Votes](block-verification-and-synchronization.md#majority-votes)

## [Block Mining](mining.md##bitmark-mining)

* [Overview](mining.md#overview)
* [Block Diagram](mining.md#block-diagram)
* [Hashing](mining.md#hashing)
* [Difficulty](mining.md#difficulty)
* [Communication](mining.md#communication)
* [Verification and Broadcast](mining.md#verification-and-broadcast)
* [Reward](mining.md#reward)

## [RPC Communication](rpc-communication.md)

* [Overview](rpc-communication.md#overview)
* [RPC Flow](rpc-communication.md#rpc-flow)
  * [Initializing](rpc-communication.md#initializing)
  * [Processing Messages](rpc-communication.md#processing-messages)

##  [Payment Verification](payment-verification.md#payment-verification)

* [Overview](payment-verification.md#overview)
* [Reservoir Module](payment-verification.md#reservoir-module)
  * [Processing a New Transaction](payment-verification.md#processing-a-new-transaction)
  * [Generating a Payment Id](payment-verification.md#generating-a-payment-id)
  * [Changing the State of a Paid Transaction](payment-verification.md#changing-the-state-of-a-paid-transaction)
  * [Pending and Verified Structures](payment-verification.md#pending-and-verified-structures)
* [Payment Module](payment-verification.md#payment-module)
  * [Using RPC APIs](payment-verification.md#using-rpc-apis)
  * [Using Discovery Service](payment-verification.md#using-discovery-service)
  * [Using Bitcoin Peer-to-Peer Protocol (WIP)](payment-verification.md#using-bitcoin-peer-to-peer-protocol-wip)

## [Storage Databases](node-modules.md)

* [Blocks DB](node-modules.md#blocks-db)
* [Index DB](node-modules.md#index-db)
* [Use Cases](node-modules.md#use-cases)

## [Blockchain Security](security.md#security-feature-of-the-bitmark-blockchain)

* [Transactions](security.md#transactions)
* [Transaction Identifiers](security.md#transaction-identifiers)
* [Block Identifiers](security.md#block-identifiers)
* [Proof of Work and Difficulty](security.md#proof-of-work-and-difficulty)

