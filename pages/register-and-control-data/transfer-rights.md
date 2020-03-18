---
title: Transfer rights
keywords: transfer rights
last_updated: 
sidebar: mydoc_sidebar
permalink: /register-and-control-data/transfer-rights
folder: register-and-control-data
---

# Transfer rights

Once an asset has been registered, the owner can trade it by creating a transfer record that points back to the original issue record (or to a previous transfer record) and that lists the new owner of the asset. Because the blockchain is ordered and because it's immutable, this creates a permanent chain of custody reaching back to the asset's origins.


There are two types of transferring a bitmark from one Bitmark account to another:

* One-signature transfer: only requires the sender's signature
* Two-signature transfer: requires both the sender's and the recipient's signature

The one-signature transfer is similar to sending emails: the sender does not get consent from the recipient before sending the mail.

The two-signature transfer is similar to certified mail or a package delivery that requires a signature: the recipient has the right to accept or reject the delivery of a package. The actual transfer won't take effect until the recipient explicitly provides the second signature, a.k.a. countersignature, as consent.


Bitmark owners can transfer their bitmarks to others using the [SDK](#transfer-bitmarks-using-the-sdk) and the [CLI](#transfer-bitmarks-using-the-cli).

## Prerequisites

**Using the SDK**
* [Install the SDK](sdk/getting-started.md#installing-sdk-packages)
* [Acquire an API token](sdk/getting-started.md#acquiring-an-api-token)

**Using the CLI**
* [Install the CLI along with the bitmarkd](run-a-node.md)
* [Install and configure the Bitmark Wallet](cli/cli-payment.md#installing-and-configuring-the-bitmark-wallet)


## Transfer bitmarks using the SDK

Each bitmark transfer requires the same transaction fee to be executed. SDK users pay for this transaction fee via the SDK credit system. 

### Execute a one-signature transfer

A one-signature transfer is initiated and executed only by the sender.

{% codetabs %}
{% codetab JS %}
```javascript
//Import the sender account
let sender = Account.fromSeed("your_account_seed");

//Build and sign the transfer request
let params = Bitmark.newTransferParams(recipientAccountNumber);
await params.fromBitmark(bitmarkId); // asynchronous, just to check the head_id
// params.fromTxId(latestTxId); // or synchronous
params.sign(sender);

//Submit the transfer
let response = await Bitmark.transfer(params);
```
{% endcodetab %}
{% codetab Swift %}
```swift
// Import the sender account
sender = Account(fromSeed:"your_account_seed");

// Build and sign the transfer request
var params = try Bitmark.newTransferParams(to: recipientAccountNumber)
try params.from(bitmarkID: bitmarkId)
try params.sign(sender)

// Submit the transfer
let txId = try Bitmark.transfer(params)
```
{% endcodetab %}
{% codetab Java %}
```java
// Import the sender account
Account sennder = Account.fromSeed("your_account_seed");

// Get the link from bitmarkId
// You can use traditional callback or modern await
// Use await for better code but don't forget to catch exceptions maybe occur
BitmarkRecord bitmark = await((Callable1<GetBitmarkResponse>) callback -> Bitmark.get(bitmarkId, callback)).getBitmark();
String link = bitmark.getHeadId();            

// Build and sign the transfer request
TransferParams params = new TransferParams(recipientAccountNumber, link);
params.sign(sender);

//Submit the transfer
Bitmark.transfer(params, new Callback1<String>() {
            @Override
            public void onSuccess(String txId) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```
{% endcodetab %}
{% codetab Go %}
```go
// Import the sender account
sender, err := account.FromSeed("your_account_seed");

// Build and sign the transfer request
params, _ := bitmark.NewTransferParams(recipientAccountNumber)
params.FromBitmark(bitmarkId)
params.Sign(sender)

// Submit the transfer
txID, err := bitmark.Transfer(params)
```
{% endcodetab %}
{% endcodetabs %}


### Execute a two-signature transfer

For some scenarios, the sender wants to get a permission from the recipient before transferring a property. In the case, the sender initiates a two-signature transfer. 
<br>

**Propose a transfer offer**

The sender initiates a two-signature transfer by propsing a transfer offer

{% codetabs %}
{% codetab JS %}
```javascript
// Import the sender account
let sender = Account.fromSeed("your_account_seed");

// Build and sign the transfer offer
let params = Bitmark.newTransferOfferParams(recipientAccountNumber);
await params.fromBitmark(bitmarkId); // asynchrous, just to check the head_id
// params.fromTxId(lastestTxId); // or synchrous
params.sign(senderAccount);

// Submit the transfer offer
let response = await Bitmark.offer(params);
```
{% endcodetab %}
{% codetab Swift %}
```swift
// Import the sender account
sender = Account(fromSeed:"your_account_seed");

// Build and sign the transfer offer
var params := Bitmark.newOfferParams(to: recipientAccountNumber, info: nil) // info: extra info attach to the transfer offer, it can be nil
try params.from(bitmarkID: bitmarkId)
try params.sign(account)

// Submit the transfer offer
try Bitmark.offer(withOfferParams: params)
```
{% endcodetab %}
{% codetab Java %}
```java
// Import the sender account
Account sennder = Account.fromSeed("your_account_seed");

// Get the link from bitmarkId
// You can use traditional callback or modern await
// Use await for better code but don't forget to catch exceptions maybe occur
BitmarkRecord bitmark = await((Callable1<GetBitmarkResponse>) callback -> Bitmark.get(bitmarkId, callback)).getBitmark();
String link = bitmark.getHeadId();            

// Build and sign the transfer offer
TransferOfferParams params = new TransferOfferParams(recipient, link);
params.sign(senderKey);

// Submit the transfer offer
Bitmark.offer(params, new Callback1<String>() {
            @Override
            public void onSuccess(String txId) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```
{% endcodetab %}
{% codetab Go %}
```go
// Import the sender account
sender, err := account.FromSeed("your_account_seed");

// Build and sign the transfer offer
params, _ := bitmark.NewOfferParams(recipientAccountNumber, nil)
params.FromBitmark(bitmarkId)
params.Sign(sender)

// Submit the transfer offer
err := bitmark.Offer(params)
```
{% endcodetab %}
{% endcodetabs %}
<br>

**Accept a transfer offer**

If the receiver decides to accept the bitmark transfer offer, they generate a countersignature, and the transfer action takes effect.

The status of the bitmark will change from `offering` to `transferring`.

{% codetabs %}
{% codetab JS %}
```javascript
// Import the recipient account
let recipient = Account.fromSeed("your_account_seed");

// Build and sign the response
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.ACCEPT);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchrous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchrous
transferOfferResponseParams.sign(recipientAccount);

// Submit the response
response = await Bitmark.response(transferOfferResponseParams, recipientAccount);

```
{% endcodetab %}
{% codetab Swift %}
```swift
// Import the recipient account
recipient = Account(fromSeed:"your_account_seed");

// Build and sign the response
var responseParams = try Bitmark.newTransferResponseParams(withBitmark: receivingBitmark, action: .accept)
try responseParams.sign(recipientAccount)

// Submit the response
try Bitmark.response(withResponseParams: responseParams)

```
{% endcodetab %}
{% codetab Java %}
```java
// Import the recipient account
Account recipient = Account.fromSeed("your_account_seed");

// Build and sign the response
TransferResponseParams params = TransferResponseParams.accept(offerRecord);
params.sign(recipient);

// Submit the response
Bitmark.respond(params, new Callback1<String>() {
            @Override
            public void onSuccess(String txId) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });

```
{% endcodetab %}
{% codetab Go %}
```go
// Import the recipient account
recipient, err := account.FromSeed("your_account_seed");

// Build and sign the response
bmk, _ := bitmark.Get(bitmarkId)
params := bitmark.NewTransferResponseParams(bmk, bitmark.Accept)
params.Sign(recipient)

// Submit the response
response, err := bitmark.Respond(params)

```
{% endcodetab %}
{% endcodetabs %}
<br>

**Reject a transfer offer**

The receiver can also reject a bitmark transfer offer.
The status of the bitmark will reverted to `settled`, and the sender can create a new transfer offer.

{% codetabs %}
{% codetab JS %}
```javascript
// Import the recipient account
let recipient = Account.fromSeed("your_account_seed");

// Build and sign the response
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.REJECT);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchrous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchrous
transferOfferResponseParams.sign(recipientAccount);

// Submit the response
response = await Bitmark.response(transferOfferResponseParams, recipientAccount);

```
{% endcodetab %}
{% codetab Swift %}
```swift
// Import the recipient account
recipient = Account(fromSeed:"your_account_seed");

// Build and sign the response
var responseParams = try Bitmark.newTransferResponseParams(withBitmark: receivingBitmark, action: .reject)
try responseParams.sign(recipientAccount)

// Submit the response
try Bitmark.response(withResponseParams: responseParams)

```
{% endcodetab %}
{% codetab Java %}
```java
// Import the recipient account
Account recipient = Account.fromSeed("your_account_seed");

// Build and sign the response
TransferResponseParams params = TransferResponseParams.reject(offerRecord);
params.sign(recipient);

// Submit the response
Bitmark.respond(params, new Callback1<String>() {
            @Override
            public void onSuccess(String txId) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });

```
{% endcodetab %}
{% codetab Go %}
```go
// Import the recipient account
recipient, err := account.FromSeed("your_account_seed");

// Build and sign the response
bmk, _ := bitmark.Get(bitmarkId)
params := bitmark.NewTransferResponseParams(bmk, bitmark.Reject)
params.Sign(recipient)

// Submit the response
response, err := bitmark.Respond(params)
```
{% endcodetab %}
{% endcodetabs %}
<br>

**Cancel a transfer offer**

If the recipient hasn't responded to a transfer offer (neither accepted nor rejected it), the sender can cancel the offer.

Similar to the case of the recipient rejecting the offer, the status of the bitmark will be set to `settled` again, and the bitmark becomes available for a new transfer.

{% codetabs %}
{% codetab JS %}
```javascript
// Import the sender account
let sender = Account.fromSeed("your_account_seed");

// Build, sign and submit the cancellation
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.CANCEL);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchronous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchronous
response = await Bitmark.response(transferOfferResponseParams, sender);
```
{% endcodetab %}
{% codetab Swift %}
```swift
// Import the sender account
sender = Account(fromSeed:"your_account_seed");

//Build and sign the cancellation
var responseParams = try Bitmark.newTransferResponseParams(withBitmark: bitmark, action: .cancel)
try responseParams.sign(sender)

// Submit the cancellation
try Bitmark.response(withResponseParams: responseParams)
```
{% endcodetab %}
{% codetab Java %}
```java
// Import the sender account
Account sennder = Account.fromSeed("your_account_seed");

// Build and sign the cancellation
TransferResponseParams params = TransferResponseParams.cancel(offerRecord, sender);
params.sign(senderKey);

//Submit the cancellation
Bitmark.respond(params, new Callback1<String>() {
            @Override
            public void onSuccess(String txId) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```
{% endcodetab %}
{% codetab Go %}
```go
// Import the sender account
sender, err := account.FromSeed("your_account_seed");

// Build and sign the cancellation
bmk, _ := bitmark.Get("YOUR BITMARK ID")
sender, _ := account.FromSeed("USER_A_SEED")
params := bitmark.NewTransferResponseParams(bmk, bitmark.Cancel)
params.Sign(sender)

// Submit the cancellation
_, err := bitmark.Respond(params)
```
{% endcodetab %}
{% endcodetabs %}
<br>

**Query transfer offers**

A user is able to query to check if some transfer offers are existing with some certain conditions. 
For the details of query execution, please refer to the [SDK Query](sdk/query.md).

{% codetabs %}
{% codetab JS %}
```javascript
let bitmarkQueryParams = Bitmark.newBitmarkQueryBuilder()
    .offerFrom("e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog")
    .limit(10)
    .build();

let response = await Bitmark.list(bitmarkQueryParams);
```
{% endcodetab %}
{% codetab Swift %}
```swift
let query = try Bitmark.newBitmarkQueryParams()
    .limit(size: 100)
    .offer(from: "e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog")
let bitmarks = try Bitmark.list(params: query)
```
{% endcodetab %}
{% codetab Java %}
```java
BitmarkQueryBuilder builder = new BitmarkQueryBuilder().offerFrom("e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog");
Bitmark.list(builder, new Callback1<GetBitmarksResponse>() {
            @Override
            public void onSuccess(GetBitmarksResponse res) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```
{% endcodetab %}
{% codetab Go %}
```go
builder := bitmark.NewQueryParamsBuilder().OfferTo("YOUR RECIPIENT ACCOUNT NUMBER")
bitmarks, referencedAssets, err := bitmark.List(builder)
```
{% endcodetab %}
{% endcodetabs %}


## Transfer bitmarks using the CLI

The Bitmark CLI allows users to transfer bitmarks by submitting the transactions to its connected node and then broadcasting to the network. The CLI users pay for their transactions by sending BTC or LTC to the indicated addresses.

{% codetabs %}
{% codetab Command %}
```shell
# Submit a transfer request
$ bitmark-cli -n <network> -i <sender identity> transfer -r <recipient> -t <txId> -u

# Run the bitcoind
$ bitcoind -datadir=<bitcoind config dir>
# OR run the litecoind
$ litecoind -datadir=<litcoind config dir>
#Pay the transfer fee by BTC
$ bitmark-wallet --conf <Bitmark-Wallet config file> btc --<btc network> sendmany --hex-data '<payId>' '<btc address>,<btc amount in satoshi>'
#OR Pay the transfer fee by LTC
$ bitmark-wallet --conf <Bitmark-Wallet config file> ltc --<ltc network> sendmany --hex-data '<payId>' '<ltc address>,<ltc amount in photon>'

# Check the transfer transaction status
$ bitmark-cli -n <network> status -t <transferId>


# Verify the bitmark provenance
$ bitmark-cli -n <network> provenance -t <transferID>

```
{% endcodetab %}
{% codetab Example %}
```shell
# Submit a transfer request
$ bitmark-cli -n testing -i first transfer -r second -t 6b35dfb5d623f6cae22fd03b3e28f1fde5255a29c1328a5d39ddfdfcd0ce6cf9 -u

# run litecoind
$ litecoind -datadir=~/.config/litecoin/
# Pay the transfer fee
$ bitmark-wallet --conf ~/.config/bitmark-wallet/test/test-bitmark-wallet.conf ltc --testnet sendmany --hex-data 'd819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e' 'mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds,200000'

# Check the transfer transaction status
$ bitmark-cli -n testing status -t 4656604222152d08606d42a40c8590c2100c177cafe374ea90bae30c5bd371e0


# Verify the bitmark provenance
$ bitmark-cli -n testing provenance -t 4656604222152d08606d42a40c8590c2100c177cafe374ea90bae30c5bd371e0

```
{% endcodetab %}
{% codetab Output %}
```json
// Submit a transfer request
/*=========================*/
{
  "transferId": "4656604222152d08606d42a40c8590c2100c177cafe374ea90bae30c5bd371e0",
  "bitmarkId": "7e3337ae7596864e6dfd918c07780480ef80cea96fa039ed17d35c3849fcb3ca",
  "payId": "d819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e",
  "payments": {
    "BTC": [
      {
        "currency": "BTC",
        "address": "mr8DEygRvQwKfP4sVZuHVozqvzW89e193j",
        "amount": "20000"
      }
    ],
    "LTC": [
      {
        "currency": "LTC",
        "address": "mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds",
        "amount": "200000"
      }
    ]
  }
},
"commands": {
  "BTC": "bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf btc --testnet sendmany --hex-data 'd819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e' 'mnTuuYNZmmswFT8iqr7ex82HAQYLJ8LXkC,10000' 'mr8DEygRvQwKfP4sVZuHVozqvzW89e193j,20000'",
  "LTC": "bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf ltc --testnet sendmany --hex-data 'd819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e' 'mzkCaHJmu1gdnsL9jxW2bwqtw2MCCy66Ds,200000'"
}

// Pay the transfer fee
/*====================*/
{
  "txId": "ca94ae188ba8bfdc42e026950c5e13a2f1082dae484a45c5dc29217ac0c9a23f",
  "rawTx": "0100000001b76a37054a086c5bd68afd61914bb4badc78c9e7ef59e6b692777cc18063632d020000006b483045022100db6f27ec3e1e59c34887f262217d5ff819947c561f0ecd11034ba8b32dbdc87002203ef82d80be8e43434eb16e22248e4533a1d3c2831e19802ce55a308604d76f3c012103b45a55c3e48209581d63ba5ceea9a0e94ae49e18056d85a6dadec535dbe237a2ffffffff03400d0300000000001976a914d2ebb7b259fb7410dca19b707c4091195d818ac488ac8091e305000000001976a9142d477753d17099534f9249b54cda36081d4e5eba88ac0000000000000000326a30d819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e00000000"
}

// Check the transfer transaction status right after the payment
/*=============================================================*/
{
  "status": "Verified"
}
// Check the transfer transaction status after some minutes
{
  "status": "Confirmed"
}

// Verify the bitmark provenance
/*=============================*/
{
  "data": [
    {
      "record": "BitmarkTransferUnratified",
      "isOwner": true,
      "txId": "4656604222152d08606d42a40c8590c2100c177cafe374ea90bae30c5bd371e0",
      "inBlock": 31101,
      "data": {
        "escrow": null,
        "link": "7e3337ae7596864e6dfd918c07780480ef80cea96fa039ed17d35c3849fcb3ca",
        "owner": "fPWWkW45o12er6oP4EveaURHXstkSXR3odWCgpaDvEvxoR3woC",
        "signature": "1d378c7e...7dafcc02"
      },
      "_IDENTITY": "second"
    },
    {
      "record": "BitmarkIssue",
      "isOwner": false,
      "txId": "7e3337ae7596864e6dfd918c07780480ef80cea96fa039ed17d35c3849fcb3ca",
      "inBlock": 31100,
      "data": {
        "assetId": "813b2eb5...de9219a7",
        "nonce": 0,
        "owner": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
        "signature": "4581ee97...9b24f20f"
      },
      "_IDENTITY": "first"
    },
    {
      "record": "AssetData",
      "isOwner": false,
      "inBlock": 31100,
      "assetId": "813b2eb5...de9219a7",
      "data": {
        "fingerprint": "01cdb27c...50514f0c",
        "metadata": "Key1\u0000Value1\u0000Key2\u0000Value2",
        "name": "Example asset 3",
        "registrant": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
        "signature": "d6cc18e5...47efe909"
      },
      "_IDENTITY": "first"
}
```
{% endcodetab %}
{% endcodetabs %}

For the details of CLI commands and their parametters, please refer to the [CLI command reference](cli/cli-command-reference.md).


## Explore the transactions using the Registry website

Users can explore all of the transactions on the Bitmark blockchain using the Bitmark Registry website:

* [Explore transactions on the Bitmark blockchain](https://registry.bitmark.com)

* [Explore transactions on the Bitmark testnet blockchain](https://registry.test.bitmark.com)


## References

CLI
  * [CLI command reference](cli/cli-command-reference.md)
  * [CLI quick setup](cli/cli-quick-setup.md)


SDK
  * [SDK Getting Started](sdk/getting-started.md)
  * [SDK Account](sdk/account.md)
  * [SDK Action](sdk/action.md)
  * [SDK Query](sdk/query.md)
  * [SDK Migration](sdk/migration.md)
  * [SDK Store Seed](sdk/store-seed.md)
  * [SDK Web Socket](sdk/websocket.md)