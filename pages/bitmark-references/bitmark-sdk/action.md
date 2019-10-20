---
title: Action
keywords: action, sdk, register asset, issue bitmark, transfer bitmark
last_updated: 
sidebar: mydoc_sidebar
permalink: action.html
folder: bitmark-references/bitmark-sdk
---

# Register an asset

The first step to create a digital property is to register assets.
An asset can any digital object, including files, applications, code, and data.

Each asset can described by name and metadata (both optional), and can be uniquely identified by its fingerprint.

If an asset record with the same fingerprint value already exists in the blockchain, the new asset record is rejected from incorporation in the blockchain.

An asset record won't be added to the blockchain without accompanying bitmark issuances (refer to the next section for more info). The "orphaned" asset records will be vanished after 3 days.

```javascript
let params = Asset.newRegistrationParams(assetName, metadata);
await params.setFingerprint(filePath);
params.sign(account);

let response = await Asset.register(params);
```

```swift
var params = try Asset.newRegistrationParams(name: "asset_name",
                                            metadata: ["desc": "sdk example"])

let fileURL = Bundle.main.url(forResource: "file", withExtension: ".ext")!
try params.setFingerprint(fromFileURL: fileURL)
try params.sign(account)

let assetId = try Asset.register(params)
```

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

# Issue bitmarks

This system records ownership claims for digital assets as digital property titles known as bitmarks.

After the asset is registered, you can issue bitmarks with a permanent reference to the corresponding asset record.

```javascript
let params = Bitmark.newIssuanceParams(assetId, quantity = 100);
params.sign(account);

let bitmarkIds = Bitmark.issue(params);
```

```swift
var params = try Bitmark.newIssuanceParams(assetId: assetId,
                                            owner: issuer.accountNumber,
                                            quantity: 100)
try params.sign(issuer)

let bitmarkIds = try Bitmark.issue(params)
```

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

```go
issuer, _ := account.FromSeed("USER_A_SEED")
params := bitmark.NewIssuanceParams("YOUR ASSET ID", 10)
params.Sign(issuer)
bitmarkIDs, err := bitmark.Issue(params)
```

# Transfer a bitmark

Bitmark transfer, which is the process of transferring bitmark ownership from one Bitmark account to another.

There are two ways to transfer a bitmark:

- **direct transfer** (1-sig transfer): only requires sender's signature
- **countersigned transfer** (2-sig transfer):requires both sender's and receiver's signature

Direct transfer is similar to sending emails, the sender does not get the consent from the receiver before sending a mail.

Countersigned transfer is similar to certified mail or a package delivery that requires a signature, the receiver has the right to accept or reject the delivery of a package.
The actual transfer won't take effect until the receiver explicitly provides the second signature, a.k.a. countersignature, as the consent.

A newly created bitmark can be transferred right after the issue tx is sent. After the first transfer transaction, any transfer can only be executed when the previous transfer transaction is already confirmed on the blockchain (i.e., the status of the bitmark has to be `settled`).

## Direct transfer

The sender can transfer a bitmark to another account without additional consent.

```javascript
let params = Bitmark.newTransferParams(receiverAccountNumber);
await params.fromBitmark(bitmarkId); // asynchronous, just to check the head_id
// params.fromTxId(latestTxId); // or synchronous
params.sign(account);

let response = await Bitmark.transfer(params);
```

```swift
var params = try Bitmark.newTransferParams(to: receiverAccountNumber)
try params.from(bitmarkID: bitmarkId)
try params.sign(account)

let txId = try Bitmark.transfer(params)
```

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

```go
sender, _ := account.FromSeed("USER_A_SEED")
params, _ := bitmark.NewTransferParams("YOUR RECEIVER ACCOUNT NUMBER")
params.FromBitmark("YOUR BITMARK ID")
params.Sign(sender)
txID, err := bitmark.Transfer(params)
```

## Countersigned transfer

For some scenario, the developer want to get a permission from the receiver before we transfer a property to it. In the case, you will submit a two-signature transfer.

### Propose a bitmark transfer offer

The current owner of a bitmark can propose a transfer offer for another account. The actual ownership transfer won't happen until the receiver accepts the offer.

```javascript
let params = Bitmark.newTransferOfferParams(receiverAccountNumber);
await params.fromBitmark(bitmarkId); // asynchrous, just to check the head_id
// params.fromTxId(lastestTxId); // or synchrous
params.sign(senderAccount);
let response = await Bitmark.offer(params);
```

```swift
var params := Bitmark.newOfferParams(to: receiverAccountNumber, info: nil) // info: extra info attach to the transfer offer, it can be nil
try params.from(bitmarkID: bitmarkId)
try params.sign(account)

try Bitmark.offer(withOfferParams: params)
```

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

```go
sender, _ := account.FromSeed("USER_A_SEED")
params, _ := bitmark.NewOfferParams("YOUR RECEIVER ACCOUNT NUMBER", nil)
params.FromBitmark("YOUR BITMARK ID")
params.Sign(sender)
err := bitmark.Offer(params)
```

### Query offering bitmarks

The receiver needs to query if there is any bitmark transfer offer waiting for the countersignature.
For the details of query execution, please refer to [Query Bitmark](query.md##Bitmark).

```javascript
let bitmarkQueryParams = Bitmark.newBitmarkQueryBuilder()
    .offerFrom("e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog")
    .limit(10)
    .build();

let response = await Bitmark.list(bitmarkQueryParams);
```

```swift
let query = try Bitmark.newBitmarkQueryParams()
    .limit(size: 100)
    .offer(from: "e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog")
let bitmarks = try Bitmark.list(params: query)
```

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

```go
builder := bitmark.NewQueryParamsBuilder().OfferTo("YOUR RECEIVER ACCOUNT NUMBER")
bitmarks, referencedAssets, err := bitmark.List(builder)
```

### Accept the bitmark transfer offer

If the receiver decides to accept the bitmark, the countersignature is generated and make the transfer action take effect.

The status of the bitmark will change from `offering` to `transferring`.

```javascript
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.ACCEPT);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchrous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchrous
transferOfferResponseParams.sign(receiverAccount);

response = await Bitmark.response(transferOfferResponseParams, receiverAccount);
```

```swift
var responseParams = try Bitmark.newTransferResponseParams(withBitmark: receivingBitmark, action: .accept)
try responseParams.sign(receiverAccount)
try Bitmark.response(withResponseParams: responseParams)
```

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

```go
bmk, _ := bitmark.Get("YOUR BITMARK ID")
receiver, _ := account.FromSeed("USER_B_SEED")
params := bitmark.NewTransferResponseParams(bmk, bitmark.Accept)
params.Sign(receiver)
_, err := bitmark.Respond(params)
```

### Reject the transfer offer

The receiver can also reject the bitmark transfer offer.
The status of the bitmark will reverted to `settled`, and the sender can create a new transfer offer.

```javascript
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.REJECT);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchronous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchronous
transferOfferResponseParams.sign(receiverAccount);

response = await Bitmark.response(transferOfferResponseParams, receiverAccount);
```

```swift
var responseParams = try Bitmark.newTransferResponseParams(withBitmark: receivingBitmark, action: .reject)
try responseParams.sign(receiverAccount)
try Bitmark.response(withResponseParams: responseParams)
```

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

```go
bmk, _ := bitmark.Get("YOUR BITMARK ID")
receiver, _ := account.FromSeed("USER_B_SEED")
params := bitmark.NewTransferResponseParams(bmk, bitmark.Reject)
params.Sign(receiver)
_, err := bitmark.Respond(params)
```

### Cancel the transfer offer

If the receiver hasn't responded to the bitmark transfer offer (neither accepted nor rejected), the sender can cancel the offer.

Similar to the case of the receiver rejecting the offer, the status of the bitmark will be set to `settled` again, and becomes available for the next transfer.

```javascript
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.CANCEL);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchronous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchronous

response = await Bitmark.response(transferOfferResponseParams, senderAccount);
```

```swift
var responseParams = try Bitmark.newTransferResponseParams(withBitmark: bitmark, action: .cancel)
try responseParams.sign(senderAccount)
try Bitmark.response(withResponseParams: responseParams)
```

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

```go
bmk, _ := bitmark.Get("YOUR BITMARK ID")
sender, _ := account.FromSeed("USER_A_SEED")
params := bitmark.NewTransferResponseParams(bmk, bitmark.Cancel)
params.Sign(sender)
_, err := bitmark.Respond(params)
```
