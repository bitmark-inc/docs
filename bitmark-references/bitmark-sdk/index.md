---
layout: default
permalink: /bitmark-references/bitmark-sdk/
---

# Bitmark SDK

## [Overview](bitmark-sdk-document#overview)

## [Getting Started](bitmark-sdk-document#getting-started)

* [Installation](bitmark-sdk-document#installation)
* [Get your API token](bitmark-sdk-document#get-your-api-token)
* [Configuration](bitmark-sdk-document#configuration)


## [Account](account#account)

* [Create an account](account#create-an-account)
* [Get the account number](account#get-the-account-number)
* [Export an account](account#export-an-account)
  * [Seed](account#seed)
  * [Recovery Phrase](account#recovery-phrase)
* [Import an account](account#import-an-account)
  * [Recover from seed](account#recover-from-seed)
  * [Recover from phrase](account#recover-from-phrase)
* [Sign and Verify](account#sign-and-verify)
* [Validate an account number](account#validate-an-account-number)


## [Actions](action)

* [Register an asset](action#register-an-asset)
* [Issue bitmarks](action#issue-bitmarks)
* [Transfer a bitmark](action#transfer-a-bitmark)
  * [Direct transfer](action#direct-transfer)
  * [Countersigned transfer](action#countersigned-transfer)
    * [Propose a bitmark transfer offer](action#propose-a-bitmark-transfer-offer)
    * [Query offering bitmarks](action#query-offering-bitmarks)
    * [Accept the bitmark transfer offer](action#accept-the-bitmark-transfer-offer)
    * [Reject the transfer offer](action#reject-the-transfer-offer)
    * [Cancel the transfer offer](action#cancel-the-transfer-offer)


## [Query](query#query)

* [Asset](query#asset)
  * [Record data structure](query#record-data-structure)
  * [Query for a specific asset](query#query-for-a-specific-asset)
  * [Query for a set of assets](query#query-for-a-set-of-assets)
    * [assets registered by the specific registrant](query#assets-registered-by-the-specific-registrant)
* [Transaction (tx)](query#transaction-tx)
  * [Record data structure](query#record-data-structure-1)
  * [Query for a specific transaction](query#query-for-a-specific-transaction)
  * [Query for a set of transactions](query#query-for-a-set-of-transactions)
    * [The provenance of a bitmark](query#the-provenance-of-a-bitmark)
    * [The transaction history of an account](query#the-transaction-history-of-an-account)
* [Bitmark](query#bitmark)
  * [Record data structure](query#record-data-structure-2)
    * [offer](query#offer)
  * [Query for a specific bitmark](query#query-for-a-specific-bitmark)
  * [Query for a set of bitmarks](query#query-for-a-set-of-bitmarks)
    * [bitmarks issued by the specific issuer](query#bitmarks-issued-by-the-specific-issuer)
    * [bitmarks owned by the specific owner](query#bitmarks-owned-by-the-specific-owner)
    * [bitmarks offered from the specific sender](query#bitmarks-offered-from-the-specific-sender)
    * [bitmarks offered to the specific receiver](query#bitmarks-offered-to-the-specific-receiver)


## [Store Seed](store-seed#store-seed)
  
* [Android](store-seed#android)
* [iOS](store-seed#ios)


## [Web Socket](websocket#web-socket)
  
* [Event](websocket#event)
* [Java](websocket#java)
    * [Connect/Disconnect](websocket#connectdisconnect)
    * [Subscribe/Unsubscribe](websocket#subscribeunsubscribe)
* [Swift](websocket#swift)

