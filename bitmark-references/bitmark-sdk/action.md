# Register an asset

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
Address registrant = account.toAddress();
RegistrationParams params = new RegistrationParams("asset_name", metadata, registrant);
params.generateFingerprint(file);
params.sign(key);
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
import (
	"github.com/bitmark-inc/bitmark-sdk-go/account"
	"github.com/bitmark-inc/bitmark-sdk-go/asset"
)

// This sample assumes the SDK is already correctly initialized
func registerAssetExample(owner account.Account) {
    params, err := asset.NewRegistrationParams(
        "name", // asset name
        map[string]string{"k1": "v1", "k2": "v2"}, // asset metadata
    )

    dat, err := ioutil.ReadFile("/tmp/dat")
    params.SetFingerprint(dat) // calculate the fingerprint

    params.Sign(owner)
    params.JSON()

    assetId, err := asset.Register(p)
}
```

The first step to create a digital property is to register assets.
An asset can any digital object, including files, applications, code, and data.

Each asset is described by name and metadata (optional), and can be uniquely identified by its fingerprint.

If an asset record with the same fingerprint value already exists in the blockchain, the new asset record is rejected from incorporation in the blockchain.

<aside class="notice">

An asset record won't be added to the blockchain without accompanying bitmark issuances (refer to the next section for more info). The "orphaned" asset records will be vanished after 3 days.

</aside>

# Issue bitmarks

This system records ownership claims for digital assets as digital property titles known as bitmarks.

After the asset is registered, you can issue bitmarks with a permananent reference to the corresponding asset record. 

There can be multiple issues for the same asset, each defined by a different nonce, and each representing a different instance of the property.

## Create issuances with nonces

```javascript
let params = Bitmark.newIssuanceParams(assetId, nonces = [1, 2, ..., 100]);
params.sign(account);

let response = await Bitmark.issue(params);
```

```swift
var params = Bitmark.newIssuanceParams(assetId: assetId,
                                       nonces: [1..100])
try params.sign(issuer)

let bitmarkIds = try Bitmark.issue(params)
```

```java
Address owner = account.toAddress();
IssuanceParams params = new IssuanceParams(assetId, owner, new int[] {1, 2, 3, 4, 5});
params.sign(ownerKey);
Bitmark.issue(params, new Callback1<List<String>>() {
            @Override
            public void onSuccess(List<String> bitmarkIds) {
                
            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```

```go
import (
	"github.com/bitmark-inc/bitmark-sdk-go/account"
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func issueByNoncesExample(issuer account.Account) {
    params := bitmark.NewIssuanceParams(
        assetId,
        bitmark.QuantityOptions{
            Nonces: []uint64{uint64(1), uint64(2), uint64(3)},
        },
    )
    params.Sign(issuer)
    bitmarkIds, err := bitmark.Issue(params) // returns three bitmark IDs
}
```

Nonce is a counter value that distinguishes different issuances for the same asset of the same owner. Typically, these represent “limited editions” of a digital asset, and the nonce can be viewed as edition number.

The combination of nonce, owner and asset should be unique over the blockchain. To issue more bitmarks, developers need to make sure there is no duplicated nonces for issuing within a same owner and asset pair.

## Create issuances without nonces

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
IssuanceParams params = new IssuanceParams(assetId, owner, quantity);
params.sign(ownerKey);
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
import (
	"github.com/bitmark-inc/bitmark-sdk-go/account"
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func issueByQuantityExample(issuer account.Account) {
    params := bitmark.NewIssuanceParams(
        assetId,
        bitmark.QuantityOptions{
            Quantity: 3,
        },
    )
    params.Sign(issuer)
    bitmarkIds, err := bitmark.Issue(params) // returns three bitmark IDs
}
```

If you simply want to generate authorized copies of digital data on demand, you can set `quantity` instead. The SDK will generate random nonces automatically for issuing.

<aside class="notice">
Either <code>quantity</code> or <code>nonces</code> should be specified when issuing bitmarks. The setting of <code>nonces</code> takes precendence over <code>quantity</code>.
</aside>

# Transfer a bitmark

Bitmark transfer, which is the process of transferring bitmark ownership from one Bitmark account to another.

There are two ways to transfer a bitmark:

- **direct transfer** (1-sig transfer): only requires sender's signature
- **countersigned transfer** (2-sig transfer):requires both sender's and receiver's signature

Direct transfer is similar to sending emails, the sender does not get the consent from the receiver before sending a mail.

Countersigned transfer is similar to express delivery, the receiver has the right to accept or reject the delivery of a package.
The actual transfer won't take effect until the receiver explicitly provides the second signature, a.k.a. countersignature, as the consent.

<aside class="notice">
A bitmark can be transferred only when its status is settled.
</aside>

## Direct transfer

```javascript
let params = Bitmark.newTransferParams(receiverAccountNumber);
await params.fromBitmark(bitmarkId); // asynchrous, just to check the head_id
// params.fromTxId(lastestTxId); // or synchrous
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
Address receiver = account.toAddress();
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
import (
	"github.com/bitmark-inc/bitmark-sdk-go/account"
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func transferExample(sender account.Account) {
    params := bitmark.NewTransferParams("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9") // set receiver's account number
    params.FromBitmark("71131367bc56628bb2eee15da274e466f2ae1533c192d60c9eeef6484b1117e3") // specify which bitmark to be transferred

    // In addition to specifying bitmark directly, you can also specify the latest tx ID of this bitmark
    // params.FromLatestTx("0374d3cd9a901d0c3d084c0e1d57b2c29331eafbbd183fa4fabb40eae331a3d7")

    params.Sign(sender)
    txId, err := bitmark.Transfer(params)
}
```

The sender can transfer a bitmark to another account without additional consent.

## Countersigned transfer

For some scenario, the developer want to get a permission from the receiver before we transfer a property to it. In the case, you will submit a two-signature transfer.

### Propose a bitmark transfer offer

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
Address receiver = account.toAddress();
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
import (
	"github.com/bitmark-inc/bitmark-sdk-go/account"
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func offerBitmarkExample(sender account.Account) {
    params := bitmark.NewOfferParams(receiverAccountNumber, true)
    params.FromBitmark() // asynchrous, just to check the head_id
    // params.FromTx() // or synchrous
    params.Sign(sender)

    bitmark.Offer(params)
}
```

The current owner of a bitmark can propose a transfer offer for another account if the status of the bitmark is `settled`,
i.e. either the issue or the transfer transaction of this bitmark is already confirmed on the blockchain.
The actual ownership transfer won't happen until the receiver accepts the offer.

### Query offering bitmarks

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
import (
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func listOfferingBitmarksExample() {
    builder := bitmark.NewQueryParamsBuilder().
		OfferFrom("e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog").
		Limit(10)

    bitmarks, err := bitmark.List(builder)
}
```

The receiver needs to query if there is any bitmark transfer offer waiting for the countersignature.
For the details of query execution, please refer to [Query Bitmark](#bitmark).

### Accept the bitmark transfer offer

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

If the receiver decides to accept the bitmark, the countersignature is generated and make the transfer action take effect.
The status of the bitmark will change from `offering` to `transferring`. The 

```go
import (
    "github.com/bitmark-inc/bitmark-sdk-go/account"
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func acceptOfferExample(receiver account.Account) {
    params := bitmark.NewTransferResponseParams(bitmark, sdk.Bitmark.Accpet)
    params.Sign(receiver)
    txId, err := bitmark.Respond(params)
}
```

### Reject the transfer offer

```javascript
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.REJECT);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchrous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchrous
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
import (
    "github.com/bitmark-inc/bitmark-sdk-go/account"
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func rejectOfferExample(receiver account.Account) {
    params := bitmark.NewTransferResponseParams(bitmark, sdk.Bitmark.Reject)
    params.Sign(receiver)
    txId, err := bitmark.Respond(params)
}
```

The receiver can also reject the bitmark transfer offer.
The status of the bitmark will reverted to `settled`, and the sender can create a new transfer offer.

### Cancel the transfer offer

```javascript
let transferOfferResponseParams = Bitmark.newTransferResponseParams(BITMARK_CONSTANTS.TRANSFER_OFFER_RESPONSE_TYPES.CANCEL);
await transferOfferResponseParams.fromBitmark(bitmark.id);  // asynchrous, just to get offer from Bitmark
// transferOfferResponseParams.fromOffer(offer) // or synchrous

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
import (
    "github.com/bitmark-inc/bitmark-sdk-go/account"
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func cancelOfferExample(receiver account.Account) {
    params := bitmark.NewTransferResponseParams(bitmark, sdk.Bitmark.Cancel)
    params.Sign(receiver)
    txId, err := bitmark.Respond(params)
}
```

If the receiver hasn't responded to the bitmark transfer offer (neither accepted nor rejected), the sender can cancel the offer.
Similar to the case of the receiver rejectting the offer, the status of the bitmark will be set to `settled` again, and becomes available for the next transfer.
