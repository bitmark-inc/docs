# Query

The bitmark SDK support queries over these three records: assets, bitmarks and transactions.

Use the record ID (`asset_id`, `bitmark_id` or `tx_id`) to retrieve the specific record.

For the retrieval of a collection of records, several query helper functions are provided to select a range of records based on supplied criteria. All records support the following filters:

- `pending`: whether to include pending records (not added to the blockchain yet)
- `limit`: the maximum number of records to be returned in one request
- `offset`: <!-- TODO -->

The records **bitmark** and **transaction** support two extra query parameters:

- `referenced_asset`: <!-- TODO -->
- `load_asset`: whether to include referenced asset objects

## Asset

<!-- TODO: WHAT'S AN ASSET? -->

### Record data structure

| Attribute | Description |
| --------- | ----------- |
| id | The asset ID |
| name | The asset name |
| metadata | The asset metadata, described by key-value paris |
| fingerprint | The hash value of the asset content, which serves as the unique identifier for the asset record in the blockchain |
| registrant | The account registering the asset |
| status | Possible values: `pending`, `confirmed` |
| block_number | The block which incorporates the asset record |
| offset | An auto-incremental number which increments when the data is updated |
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

#### assets registered by the specific registrant

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
// import bmAsset "github.com/bitmark-inc/bitmark-sdk-go/asset"
params := bmAsset.NewQueryParamsBuilder().
		RegisteredBy("ec6yMcJATX6gjNwvqp8rbc4jNEasoUgbfBBGGyV5NvoJ54NXva").
		Limit(10)
assets, err := bmAsset.List(params)
```

```java
AssetQueryBuilder builder = new AssetQueryBuilder().limit(limit).registeredBy(registrant);
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

<!-- TODO: WHAT'S AN BITMARK? -->

### Record data structure

| Attribute | Description |
| --------- | ----------- |
| id | The bitmark ID |
| asset_id | The asset ID |
| latest_tx_id | The latest tx ID |
| issuer | The account issuing the bitmark |
| owner | The account currently owning the bitmark |
| offer | See the [offer](####-offer) attributes below. |
| status | Possible values: `issuing`, `transferring`, `offering`, `settled`. See the following diagram for definition. |
| block_number | The block which incorporates the latest tx of this bitmark |
| offset | An auto-incremental number which increments when the data is updated |
| created_at | When the bitmark is issued |
| confirmed_at | The last time when the bitmark is transferred |

![Bitmark status diagram](bitmark_status.png)

#### offer

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
// import bmBitmark "github.com/bitmark-inc/bitmark-sdk-go/bitmark"
bitmark, err := bmBitmark.Get("3bfe21170de3ff1767a166896cf9c69c12534b77c75509b673d02489405a5bf1")
```

### Query for a set of bitmarks

#### bitmarks issued by the specific issuer

#### bitmarks owned by the specific owner

#### bitmarks offered from the specific sender

#### bitmarks offered to the specific receiver

## Transaction (tx)

A new tx record is generated accordingly when there is an update to the bitmark ownership.

### Record data structure

| Attribute | Description |
| --------- | ----------- |
| id | The tx ID |
| owner | The account owning the bitmark |
| previous_id | Links to the previous tx (ignored for issue tx) |
| previous_owner | The previous owner of the bitmark (ignored for issue tx) |
| bitmark_id | Links to the bitmark which this tx is applied to |
| asset_id | The asset ID |
| status | Possible values: `pending`, `confirmed` |
| block_number | The block which incorporates the tx record |
| offset | An auto-incremental number which increments when the data is updated |
| confirmation | the number of blocks in the block chain that have been accepted by the network since the block that includes the transaction |
| countersign | Indicates if this tx is a 2-sig transfer |

### Query for a specific transaction

````javascript
let txResponse = await Transaction.get(txId);
````

```go
// import bmTx "github.com/bitmark-inc/bitmark-sdk-go/tx"
tx, err := bmTx.Get("3bfe21170de3ff1767a166896cf9c69c12534b77c75509b673d02489405a5bf1")
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

```swift
let tx = try Transaction.get(transactionID: "3bfe21170de3ff1767a166896cf9c69c12534b77c75509b673d02489405a5bf1")
```

### Query for a set of transactions

#### the provenance of a bitmark

<!-- TODO: what does this mean? -->

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
// import bmTx "github.com/bitmark-inc/bitmark-sdk-go/tx"
params := bmTx.NewQueryParamsBuilder().
    ReferencedBitmark("58737de5ad68a535da6277da62d11eb3ed76ff6dd7fc2adf3c42a4096d9a2518")
txs, referencedAssets, err := bmTx.List(params)
```

```java
TransactionQueryBuilder builder = new TransactionQueryBuilder()
                                .referencedBitmark("58737de5ad68a535da6277da62d11eb3ed76ff6dd7fc2adf3c42a4096d9a2518");
Transaction.list(builder, new Callback1<GetTransactionsResponse>() {
            @Override
            public void onSuccess(GetTransactionsResponse res) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });
```

#### the transaction history of an account

<!-- TODO: what does this mean? -->

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
// import bmTx "github.com/bitmark-inc/bitmark-sdk-go/tx"
params := bmTx.NewQueryParamsBuilder().
    OwnedBy("eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9")
txs, referencedAssets, err := bmTx.List(params)
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
