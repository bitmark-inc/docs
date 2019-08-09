# Query

## Asset

| Attribute | Description |
| --------- | ----------- |
| id | The asset ID |
| name | The asset name |
| metadata | The asset metadata, described by key-value paris |
| fingerprint | The hash value of the asset content, which serves as the unique identifier for the asset record in the blockchain |
| registrant | The account registering the asset |
| status | Possible values: `pending`, `confirmed` |
| block_number | The block which incorporates the asset record |
| created_at | When the asset status becomes `confirmed` |

### Query for a specific asset
````javascript
let response = await Asset.get(assetId);
````

````swift
let response = Asset.get(assetID: assetId)
````

```go
import (
	"github.com/bitmark-inc/bitmark-sdk-go/asset"
)

// This sample assumes the SDK is already correctly initialized
func getAssetExample() {
    asset, err := asset.Get(assetId)
}
```

```java
Asset.get(assetId, new Callback1<AssetRecord>() {
            @Override
            public void onSuccess(AssetRecord asset) {
                
            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```

### Query for a set of assets
````javascript
let assetQueryParams = Asset.newAssetQueryBuilder()
    .registeredBy("ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
    .pending(true)
    .limit(10)
    .build();

let response = await Asset.list(assetQueryParams);
````

````swift
let params = try Asset.newQueryParams()
                .limit(size: 100)
                .registeredBy(registrant: "ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")

let assets = try Asset.list(params: params)
````

```go
import (
	"github.com/bitmark-inc/bitmark-sdk-go/asset"
)

// This sample assumes the SDK is already correctly initialized
func listAssetsExample() {
    params := asset.NewQueryParamsBuilder().
        RegisteredBy("ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva").
        Limit(10)
    assets, err := asset.List(params)
}
```

```java
AssetQueryBuilder builder = new AssetQueryBuilder().limit(limit).registrant(registrant);
Asset.list(builder, new Callback1<List<AssetRecord>>() {
            @Override
            public void onSuccess(List<AssetRecord> assets) {
                
            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```

## Bitmark

| Attribute | Description |
| --------- | ----------- |
| id | The bitmark ID |
| asset_id | The asset ID |
| asset | The asset record |
| latest_tx_id | The latest tx ID |
| issuer | The account issuing the bitmark |
| owner | The account currently owningthe bitmark |
| offer | See the offer attributes below. |
| status | Possible values: `issuing`, `transferring`, `offering`, `settled` See the following diagram for definition. |
| block_number | The block which incorporates the latest tx of this bitmark |
| created_at | When the bitmark is issued |
| updated_at | The last time when the bitmark is transferred |

![Bitmark status diagram](images/bitmark_status.png)

### Offer

| Attribute | Description |
| --------- | ----------- |
| id | The offer ID |
| from | Represents the account creating the offer |
| to | Represents the account which can accept/reject the bitmark |
| record | The half-signed transfer tx |
| extra_info | Attached JSON message for indicating the details of this offer |
| created_at | The create time of the offer |

### Query for a specific bitmark
````javascript
let response = await Bitmark.get(bitmarkId, false); // false: not include asset, true: include asset 
````

````swift
let bitmark = Bitmark.get(bitmarkID: bitmarkId); 
````

```go
import (
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func getBitmarkExample() {
    bitmark, err := bitmark.Get(bitmarkId, false)
}
```

### Query for a set of bitmarks
````javascript
let bitmarkQueryParams = Bitmark.newBitmarkQueryBuilder()
    .ownedBy("ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
    .issuedBy("ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
    .referencedAsset("0e0b4e3bd771811d35a23707ba6197aa1dd5937439a221eaf8e7909309e7b31b6c0e06a1001c261a099abf04c560199db898bc154cf128aa9efa5efd36030c64")
    .offerFrom("ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
    .offerTo("ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
    .loadAsset(true)
    .pending(true)
    .limit(10)
    .build();

let response = await Bitmark.list(bitmarkQueryParams);
````

````swift
let query = try Bitmark.newBitmarkQueryParams()
    .limit(size: 100)
    .issued(by: "ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
    .referenced(toAssetID: "0e0b4e3bd771811d35a23707ba6197aa1dd5937439a221eaf8e7909309e7b31b6c0e06a1001c261a099abf04c560199db898bc154cf128aa9efa5efd36030c64")
    .offer(from: "ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
    .offer(to: "ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva")
    .at(offset)
    .to(direction: .earlier)
    .loadAsset(true)
    .includePending(true)
let (bitmarks, assets) = try Bitmark.list(params: query)
````

```go
import (
	"github.com/bitmark-inc/bitmark-sdk-go/bitmark"
)

// This sample assumes the SDK is already correctly initialized
func listBitmarksExample() {
    params := bitmark.NewQueryParamsBuilder().
        IssuedBy("e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog").
        OwnedBy("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", true).
        OfferTo("dzJjGazcRuC7KhgU5o2Y2YV8wGXhBBabGRACa2Uyg4ZkVWwyNu").
        OfferFrom("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9").
        ReferencedAsset("1f21148a273b5e63773ceee976a84bcd014d88ac2c18a29cac4442120b430e158386b0ad90515c69e7d1fd6df8f3d523e3550741e88d0d04798627a57b0006c9").
        LoadAsset(true).
        Limit(10)

    bitmarks, err := bitmark.List(params)
}
```

```java
BitmarkQueryBuilder builder = new BitmarkQueryBuilder()
                            .issuedBy("e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog")
                            .ownedBy("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9")
                            .offerTo("dzJjGazcRuC7KhgU5o2Y2YV8wGXhBBabGRACa2Uyg4ZkVWwyNu")
                            .offerFrom("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9")
                            .referenceAsset("1f21148a273b5e63773ceee976a84bcd014d88ac2c18a29cac4442120b430e158386b0ad90515c69e7d1fd6df8f3d523e3550741e88d0d04798627a57b0006c9")
                            .loadAsset(true)
                            .limit(10);
Bitmark.list(builder, new Callback1<GetBitmarksResponse>() {
            @Override
            public void onSuccess(GetBitmarksResponse res) {
                
            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```

## Tx

| Attribute | Description |
| --------- | ----------- |
| id | The tx ID |
| bitmark_id | Links to the bitmark which this tx is applied to |
| asset_id | The asset ID |
| asset | The asset record |
| owner | The account owning the bitmark |
| status | Possible values: `pending`, `confirmed` |
| block_number | The block which incorporates the tx record |

A new tx record is generated accordingly when there is an update to the bitmark ownership.

### Query for a specific transaction
````javascript
let txResponse = await Transaction.get(txId);
````

```go
import (
	"github.com/bitmark-inc/bitmark-sdk-go/tx"
)

// This sample assumes the SDK is already correctly initialized
func getTxExample() {
    tx, err := tx.Get(txId, true)
}
```

```java
Transaction.get(txId, new Callback1<GetTransactionResponse>() {
            @Override
            public void onSuccess(GetTransactionResponse res) {
                
            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```

### Query for a set of transactions
````javascript
let transactionQueryParams = Transaction.newTransactionQueryBuilder()
    .ownedBy("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9")
    .referencedAsset("1f21148a273b5e63773ceee976a84bcd014d88ac2c18a29cac4442120b430e158386b0ad90515c69e7d1fd6df8f3d523e3550741e88d0d04798627a57b0006c9")
    .referencedBitmark("c8e021c1a093c32909e4d29b4624f8a5443e349a597314b7c9527ce310749121")
    .loadAsset(true)
    .limit(10)
    .build();

let response = await Transaction.list(transactionQueryParams);
````

````swift
let query = try Transaction.newTransactionQueryParams()
    .limit(size: 100)
    .owned(by: "eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", transient: true)
    .referenced(toAssetID: "0e0b4e3bd771811d35a23707ba6197aa1dd5937439a221eaf8e7909309e7b31b6c0e06a1001c261a099abf04c560199db898bc154cf128aa9efa5efd36030c64")
    .referenced(toBitmarkID: "58737de5ad68a535da6277da62d11eb3ed76ff6dd7fc2adf3c42a4096d9a2518")
    .at(offset)
    .to(direction: .earlier)
    .loadAsset(true)
    .includePending(true)
let (txs, assets) = try Transaction.list(params: query)
````

```go
import (
	"github.com/bitmark-inc/bitmark-sdk-go/tx"
)

// This sample assumes the SDK is already correctly initialized
func listTxsExample() {
    params := tx.NewQueryParamsBuilder().
        OwnedBy("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", true).
        ReferencedAsset("0e0b4e3bd771811d35a23707ba6197aa1dd5937439a221eaf8e7909309e7b31b6c0e06a1001c261a099abf04c560199db898bc154cf128aa9efa5efd36030c64").
        ReferencedBitmark("58737de5ad68a535da6277da62d11eb3ed76ff6dd7fc2adf3c42a4096d9a2518").
        LoadAsset(true).
        Limit(10)

    txs, err := tx.List(params)
}
```

```java
TransactionQueryBuilder builder = new TransactionQueryBuilder()
                                .ownedBy("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9")
                                .referenceAsset("0e0b4e3bd771811d35a23707ba6197aa1dd5937439a221eaf8e7909309e7b31b6c0e06a1001c261a099abf04c560199db898bc154cf128aa9efa5efd36030c64")
                                .referenceBitmark("58737de5ad68a535da6277da62d11eb3ed76ff6dd7fc2adf3c42a4096d9a2518")
                                .loadAsset(true)
                                .limit(10);
Transaction.list(builder, new Callback1<GetTransactionsResponse>() {
            @Override
            public void onSuccess(GetTransactionsResponse res) {
                
            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```

### Query the provenance of a bitmark
````javascript
let transactionQueryParams = Transaction.newTransactionQueryBuilder()
    .referencedBitmark("c8e021c1a093c32909e4d29b4624f8a5443e349a597314b7c9527ce310749121")
    .build();

let response = await Transaction.list(transactionQueryParams);
````

````swift
let query = try Transaction.newTransactionQueryParams()
    .referenced(toBitmarkID: "58737de5ad68a535da6277da62d11eb3ed76ff6dd7fc2adf3c42a4096d9a2518")
let (txs, _) = try Transaction.list(params: query)
````

```go
params := tx.NewQueryParamsBuilder().
    ReferencedBitmark("58737de5ad68a535da6277da62d11eb3ed76ff6dd7fc2adf3c42a4096d9a2518")
```

```java
TransactionQueryBuilder builder = new TransactionQueryBuilder()
                                .referenceBitmark("58737de5ad68a535da6277da62d11eb3ed76ff6dd7fc2adf3c42a4096d9a2518");
Transaction.list(builder, new Callback1<GetTransactionsResponse>() {
            @Override
            public void onSuccess(GetTransactionsResponse res) {
                
            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```

### Query the transaction history of an account
````javascript
let transactionQueryParams = Transaction.newTransactionQueryBuilder()
    .ownedBy("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9")
    .build();

let response = await Transaction.list(transactionQueryParams);
````

````swift
let query = try Transaction.newTransactionQueryParams()
    .owned(by: "eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", transient: true)
let (txs, _) = try Transaction.list(params: query)
````

```go
params := tx.NewQueryParamsBuilder().
    OwnedBy("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", true)
```

```java
TransactionQueryBuilder builder = new TransactionQueryBuilder()
                                .ownedBy("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9");
Transaction.list(builder, new Callback1<GetTransactionsResponse>() {
            @Override
            public void onSuccess(GetTransactionsResponse res) {
                
            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```