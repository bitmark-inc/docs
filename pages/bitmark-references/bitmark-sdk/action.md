---
title: Actions
keywords: action, sdk, register asset, issue bitmark, transfer bitmark
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-sdk/action
folder: bitmark-references/bitmark-sdk
---

# Actions

The Bitmark Property System focuses on digital assets that can be registered, issued, or transferred.

## Registering an asset

The first step in creating a digital property is registering an asset, which can be any digital object including files, applications, code, or data.

Each asset can be described by a name and by metadata (both optional) and must be uniquely identified by its fingerprint. If an asset record with the same fingerprint value already exists in the blockchain, the new asset record is rejected from incorporation in the blockchain.

An asset record won't be added to the blockchain without an accompanying bitmark issuances (see the next section for more info). Such an "orphaned" asset records will vanish after three days.

{% codetabs %}
{% codetab JS %}
```javascript
let params = Asset.newRegistrationParams(assetName, metadata);
await params.setFingerprint(filePath);
params.sign(account);

let response = await Asset.register(params);
```
{% endcodetab %}
{% codetab Swift %}
```swift
var params = try Asset.newRegistrationParams(name: "asset_name",
                                            metadata: ["desc": "sdk example"])

let fileURL = Bundle.main.url(forResource: "file", withExtension: ".ext")!
try params.setFingerprint(fromFileURL: fileURL)
try params.sign(account)

let assetId = try Asset.register(params)
```
{% endcodetab %}
{% codetab Java %}
```java
Map<String, String> metadata = new HashMap<>(){{
	put("name", "name");
	put("desc", "sdk_example");
}};
RegistrationParams params = new RegistrationParams("asset_name", metadata);
params.setFingerprintFromFile(file);
params.sign(registrantKey);
Asset.register(params, new Callback1<RegistrationResponse>() {
            @Override
            public void onSuccess(RegistrationResponse res) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```
{% endcodetab %}
{% codetab Go %}
```go
registrant, _ := account.FromSeed("USER_A_SEED")
params, _ := asset.NewRegistrationParams(
    "SDK usage example",
    map[string]string{"author": "developer@bitmark.com"},
)
params.SetFingerprintFromData([]byte("Hello, world!"))
params.Sign(registrant)
assetID, err := asset.Register(params)
```
{% endcodetab %}
{% endcodetabs %}

## Issuing a bitmark

This Bitmark Property System records ownership claims for digital assets as digital property titles known as Bitmark certificates, or bitmarks.

After an asset is registered, you can issue bitmarks with a permanent reference to the corresponding asset record.

{% codetabs %}
{% codetab JS %}
```javascript
let params = Bitmark.newIssuanceParams(assetId, quantity = 100);
params.sign(account);

let bitmarkIds = Bitmark.issue(params);
```
{% endcodetab %}
{% codetab Swift %}
```swift
var params = try Bitmark.newIssuanceParams(assetId: assetId,
                                            owner: issuer.accountNumber,
                                            quantity: 100)
try params.sign(issuer)

let bitmarkIds = try Bitmark.issue(params)
```
{% endcodetab %}
{% codetab Java %}
```java
Address owner = account.toAddress();
IssuanceParams params = new IssuanceParams(assetId, issuer, quantity);
params.sign(issuerKey);
Bitmark.issue(params, new Callback1<List<String>>() {
            @Override
            public void onSuccess(List<String> txIds) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```
{% endcodetab %}
{% codetab Go %}
```go
issuer, _ := account.FromSeed("USER_A_SEED")
params := bitmark.NewIssuanceParams("YOUR ASSET ID", 10)
params.Sign(issuer)
bitmarkIDs, err := bitmark.Issue(params)
```
{% endcodetab %}
{% endcodetabs %}

## Transferring a bitmark

There are two ways to transfer a bitmark from one Bitmark account to another:

- **direct transfer** (1-signature transfer): only requires the sender's signature
- **countersigned transfer** (2-signature transfer): requires both the sender's and the receiver's signature

Direct transfer is similar to sending emails: the sender does not get consent from the receiver before sending the mail.

Countersigned transfer is similar to certified mail or a package delivery that requires a signature: the receiver has the right to accept or reject the delivery of a package. The actual transfer won't take effect until the receiver explicitly provides the second signature, a.k.a. countersignature, as consent.

A newly created bitmark can be transferred right after the issue transaction is sent. Following the first transfer transaction, an additional transfer can only be executed when the previous transfer transaction is already confirmed on the blockchain (i.e., the status of the bitmark has to be `settled`).

### Direct transfer

The sender can transfer a bitmark to another account without additional consent.

{% codetabs %}
{% codetab JS %}
```javascript
let params = Bitmark.newTransferParams(receiverAccountNumber);
await params.fromBitmark(bitmarkId); // asynchronous, just to check the head_id
// params.fromTxId(latestTxId); // or synchronous
params.sign(account);

let response = await Bitmark.transfer(params);
```
{% endcodetab %}
{% codetab Swift %}
```swift
var params = try Bitmark.newTransferParams(to: receiverAccountNumber)
try params.from(bitmarkID: bitmarkId)
try params.sign(account)

let txId = try Bitmark.transfer(params)
```
{% endcodetab %}
{% codetab Java %}
```java
// Get the link from bitmarkId
// You can use traditional callback or modern await
// Use await for better code but don't forget to catch exceptions maybe occur
BitmarkRecord bitmark = await((Callable1<GetBitmarkResponse>) callback -> Bitmark.get(bitmarkId, callback)).getBitmark();
String link = bitmark.getHeadId();            

// Transfer bitmark
TransferParams params = new TransferParams(receiver, link);
params.sign(senderKey);
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
sender, _ := account.FromSeed("USER_A_SEED")
params, _ := bitmark.NewTransferParams("YOUR RECEIVER ACCOUNT NUMBER")
params.FromBitmark("YOUR BITMARK ID")
params.Sign(sender)
txID, err := bitmark.Transfer(params)
```
{% endcodetab %}
{% endcodetabs %}

## Countersigned transfer

For some scenarios, the sender wants to get a permission from the receiver before transferring property. In the case, the sender initiates a two-signature transfer.

### Proposing a transfer offer

The current owner of a bitmark can propose a transfer offer to another account. The actual ownership transfer won't happen until the receiver accepts the offer.

{% codetabs %}
{% codetab JS %}
```javascript
let params = Bitmark.newTransferOfferParams(receiverAccountNumber);
await params.fromBitmark(bitmarkId); // asynchrous, just to check the head_id
// params.fromTxId(lastestTxId); // or synchrous
params.sign(senderAccount);
let response = await Bitmark.offer(params);
```
{% endcodetab %}
{% codetab Swift %}
```swift
var params := Bitmark.newOfferParams(to: receiverAccountNumber, info: nil) // info: extra info attach to the transfer offer, it can be nil
try params.from(bitmarkID: bitmarkId)
try params.sign(account)

try Bitmark.offer(withOfferParams: params)
```
{% endcodetab %}
{% codetab Java %}
```java
// Get the link from bitmarkId
// You can use traditional callback or modern await
// Use await for better code but don't forget to catch exceptions maybe occur
BitmarkRecord bitmark = await((Callable1<GetBitmarkResponse>) callback -> Bitmark.get(bitmarkId, callback)).getBitmark();
String link = bitmark.getHeadId();            

// Offer bitmark
TransferOfferParams params = new TransferOfferParams(receiver, link);
params.sign(senderKey);
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
sender, _ := account.FromSeed("USER_A_SEED")
params, _ := bitmark.NewOfferParams("YOUR RECEIVER ACCOUNT NUMBER", nil)
params.FromBitmark("YOUR BITMARK ID")
params.Sign(sender)
err := bitmark.Offer(params)
```
{% endcodetab %}
{% endcodetabs %}

### Querying for offers

The receiver needs to query if there are any bitmark transfer offers waiting for their countersignature.
For the details of query execution, please refer to [Query Bitmark](query.md##Bitmark).

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
builder := bitmark.NewQueryParamsBuilder().OfferTo("YOUR RECEIVER ACCOUNT NUMBER")
bitmarks, referencedAssets, err := bitmark.List(builder)
```
{% endcodetab %}
{% endcodetabs %}

### Accepting a transfer offer

If the receiver decides to accept the bitmark transfer offer, they generate a countersignature, and the transfer action takes effect.

The status of the bitmark will change from `offering` to `transferring`.

{% codetabs %}
{% codetab JS %}
```javascript
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.ACCEPT);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchrous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchrous
transferOfferResponseParams.sign(receiverAccount);

response = await Bitmark.response(transferOfferResponseParams, receiverAccount);
```
{% endcodetab %}
{% codetab Swift %}
```swift
var responseParams = try Bitmark.newTransferResponseParams(withBitmark: receivingBitmark, action: .accept)
try responseParams.sign(receiverAccount)
try Bitmark.response(withResponseParams: responseParams)
```
{% endcodetab %}
{% codetab Java %}
```java
TransferResponseParams params = TransferResponseParams.accept(offerRecord);
params.sign(receiverKey);
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
bmk, _ := bitmark.Get("YOUR BITMARK ID")
receiver, _ := account.FromSeed("USER_B_SEED")
params := bitmark.NewTransferResponseParams(bmk, bitmark.Accept)
params.Sign(receiver)
_, err := bitmark.Respond(params)
```
{% endcodetab %}
{% endcodetabs %}

### Rejecting a transfer offer

The receiver can also reject a bitmark transfer offer.
The status of the bitmark will reverted to `settled`, and the sender can create a new transfer offer.

{% codetabs %}
{% codetab JS %}
```javascript
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.REJECT);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchronous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchronous
transferOfferResponseParams.sign(receiverAccount);

response = await Bitmark.response(transferOfferResponseParams, receiverAccount);
```
{% endcodetab %}
{% codetab Swift %}
```swift
var responseParams = try Bitmark.newTransferResponseParams(withBitmark: receivingBitmark, action: .reject)
try responseParams.sign(receiverAccount)
try Bitmark.response(withResponseParams: responseParams)
```
{% endcodetab %}
{% codetab Java %}
```java
TransferResponseParams params = TransferResponseParams.reject(offerRecord);
params.sign(receiverKey);
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
bmk, _ := bitmark.Get("YOUR BITMARK ID")
receiver, _ := account.FromSeed("USER_B_SEED")
params := bitmark.NewTransferResponseParams(bmk, bitmark.Reject)
params.Sign(receiver)
_, err := bitmark.Respond(params)
```
{% endcodetab %}
{% endcodetabs %}

### Cancelling a transfer offer

If a receiver hasn't responded to a bitmark transfer offer (neither accepted nor rejected it), the sender can cancel the offer.

Similar to the case of the receiver rejecting the offer, the status of the bitmark will be set to `settled` again, and the bitmark becomes available for a new transfer.

{% codetabs %}
{% codetab JS %}
```javascript
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.CANCEL);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchronous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchronous

response = await Bitmark.response(transferOfferResponseParams, senderAccount);
```
{% endcodetab %}
{% codetab Swift %}
```swift
var responseParams = try Bitmark.newTransferResponseParams(withBitmark: bitmark, action: .cancel)
try responseParams.sign(senderAccount)
try Bitmark.response(withResponseParams: responseParams)
```
{% endcodetab %}
{% codetab Java %}
```java
TransferResponseParams params = TransferResponseParams.cancel(offerRecord, sender);
params.sign(senderKey);
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
bmk, _ := bitmark.Get("YOUR BITMARK ID")
sender, _ := account.FromSeed("USER_A_SEED")
params := bitmark.NewTransferResponseParams(bmk, bitmark.Cancel)
params.Sign(sender)
_, err := bitmark.Respond(params)
```
{% endcodetab %}
{% endcodetabs %}
