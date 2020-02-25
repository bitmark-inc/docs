---
title: Register data
keywords: register bitmark data
last_updated: 
sidebar: mydoc_sidebar
permalink: /register-and-control-data/register-data
folder: register-and-control-data
---

# Register data

Assets with titles that have been publicly recorded are more valuable than those without. They are what grant basic rights, such as the ability to resell, rent, lend, and donate the property. The Bitmark blockchain allows individuals to access these rights for digital assets by registering their titles as Bitmark Certificates (or bitmarks). This can be done using the SDK and the CLI.

The process of registering a Bitmark Certificate for a digital asset occurs in two steps:

* Registering the asset: this creates an *Asset Record*, which is stored on the Bitmark blockchain.

* Issuing bitmarks: this creates *Issue Records* linking to the corresponding asset record, which are also stored on the Bitmark blockchain.

This process registers legal property rights on the public Bitmark blockchain for an individual's digital assets, including personal health and social data, creative works such as art, photography, and music, and other intellectual property. These legal rights determine who owns property and what can be done with it, whether the individual wants to keep it, sell it, or donate it.

## Prerequisites

**Using the SDK**
* [Install the SDK](sdk/install-the-sdk.md#installation)
* [Get your API token](sdk/install-the-sdk.md#get-your-api-token)

**Using the CLI**
* [Install the CLI along with the bitmarkd](run-a-node.md)
* [Install and configure the Bitmark Wallet](cli/cli-payment.md#installing-and-configuring-the-bitmark-wallet)

## Issue the first bitmark

The first step to create a digital property is to register assets. 

* Each asset can described by name and metadata (both optional), and can be uniquely identified by its fingerprint. 
* If an asset record with the same fingerprint value already exists in the blockchain, the new asset record is rejected from incorporation in the blockchain. 
* An asset record won't be added to the blockchain without accompanying bitmark issuances. The "orphaned" asset records will be vanished after 3 days.

For any asset there is a special issue that is free of cost. Even if an asset already exists a different Bitmark account can create a free issue for it.

### Using the SDK

{% codetabs %}
{% codetab JS %}
```javascript
//Configure the SDK
const sdk = require('bitmark-sdk-js');

const config = {
  apiToken: "api-token",
  network: "testnet"
};

sdk.init(config);

// Creat a Bitmark account
let registrant = new sdk.Account();

// Define the asset name & metadata
let name = "asset_name";
let metadata = {"desc": "js sdk example"]};

// Compute the asset fingerprint
// Build and sign the asset registration request
let params = sdk.Asset.newRegistrationParams(name, metadata);
await params.setFingerprint(filepath);
params.sign(registrant);

// Send the asset registration request
let assets = (await sdk.Asset.register(params)).assets;
let assetId = assets[0].id;

// Build and sign the bitmark issuance request
let issueParams = sdk.Bitmark.newIssuanceParams(assetId, 1);
issueParams.sign(registrant);

// Submit the issue request
let bitmarks = (await sdk.Bitmark.issue(issueParams)).bitmarks;
let bitmarkId = bitmarks[0].id;
```
{% endcodetab %}
{% codetab Swift %}
```swift
//Configure the SDK
import BitmarkSDK

BitmarkSDK.initialize(config: SDKConfig(apiToken: "api-token",
                                        network: .testnet,
                                        urlSession: URLSession.shared))

// Creat a Bitmark account
let registrant = try Account()

// Define the asset name & metadata
var params = try Asset.newRegistrationParams(name: "asset_name", metadata: ["desc": "swift sdk example"])

//Compute the asset fingerprint
//Build and sign the asset registration request
let fileURL = Bundle.main.url(forResource: "file", withExtension: ".ext")!
try params.setFingerprint(fromFileURL: fileURL)
try params.sign(registrant)

// Submit the asset registration request
let assetId = try Asset.register(params)

// Build and sign the bitmark issuance request
var params = try Bitmark.newIssuanceParams(assetId: assetId,
                                            quantity: 1)
try params.sign(registrant)

// Submit the issue request
let bitmarkIds = try Bitmark.issue(params)
```
{% endcodetab %}
{% codetab Java %}
```java
//Configure the SDK
final GlobalConfiguration.Builder builder = GlobalConfiguration.builder().withApiToken("api-token").withNetwork(Network.TEST_NET);
BitmarkSDK.init(builder);

// Create a Bitmark Account as the Issuer
Account registrant = new Account();

// Define the asset name & metadata
Map<String, String> metadata = new HashMap<>();
RegistrationParams params = new RegistrationParams("asset_name", metadata);

// Compute the asset fingerprint
// Build and sign the asset registration request
params.setFingerprintFromFile(new File(assetFilePath));
params.sign(registrant.getKeyPair());

// Submit the asset registration request
Asset.register(params, new Callback1<RegistrationResponse>() {
            @Override
            public void onSuccess(RegistrationResponse res) {

            }

            @Override
            public void onError(Throwable throwable) {

            }
        });

// Build and sign the bitmark issuance request
IssuanceParams params = new IssuanceParams(assetId, 1);
params.sign(registrant.getKeyPair());

// Submit the issue request
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
//Configure the SDK
import sdk "github.com/bitmark/bitmark-inc/bitmark-sdk-go"

func main() {
	config := &sdk.Config{
		APIToken: "YOUR API TOKEN",
		Network:  sdk.Testnet,
		HTTPClient: &http.Client{
			Timeout: 10 * time.Second,
		},
	}
	sdk.Init(config)
}

// Create a Bitmark Account as the Issuer
registrant, err := account.New()

// Compute the asset fingerprint
// Build and sign the asset registration request
params, _ := asset.NewRegistrationParams(
    "asset_name",
    map[string]string{"desc": "Go sdk example"},
)
params.SetFingerprintFromData([]byte("Hello, world!"))
params.Sign(registrant)

// Submit the asset registration request
assetID, err := asset.Register(params)

// Build and sign the bitmark issuance request
params := bitmark.NewIssuanceParams(assetID, 1)
params.Sign(issuer)

// Submit the issue request
bitmarkIDs, err := bitmark.Issue(params)
```
{% endcodetab %}
{% endcodetabs %} 

### Using the CLI

{% codetabs %}
{% codetab Command %}
```sh
# Create an identity
$ bitmark-cli -i IDENTITY -n NETWORK setup -d 'DESCRIPTION OF IDENTITY' -c HOST:2130

# Compute the asset hash
$ bitmark-cli -n <network> fingerprint -f <file>

# register asset along with issuing the first bitmark
$ bitmark-cli -n <network> -i <identity> create -a '<asset name>' -m '<asset metadata>' -f <asset fingerprint> -z

# Verify the status of the issuance transaction
$ bitmark-cli -n <network> status -t <txid>

```
{% endcodetab %}
{% codetab Example %}
```sh
# Create a Bitmark Account as the Issuer

#  Compute file hash
$ bitmark-cli -n testing fingerprint -f test.txt

# Issue the first bitmark of the asset
$ bitmark-cli -n testing -i first create -a 'asset_name' -m 'From\u0000CLI\u0000desc\u0000example' -f 0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500 -z

# Verify the status of the issuance transaction
$ bitmark-cli -n testing status -t b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23
```
{% endcodetab %}
{% codetab Output %}
```json
// Computing asset hash
{
    "file_name": "filename.test",
    "fingerprint":"0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f799c7527859361f1694acef106d5131a96641eae524e1c323500"
}

//Registering the asset from its hash
{
    "assetId": "dac17bef505f7a5acf890a1d0f232b7d847f1e951cf1f5b880de13253a10df43cdbcab553e08050808e0b3fdfd2581a798dcdf9cedbbddf4476ead14caa612d3",
    "issueIds": [
        "b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23"
    ],
    "payId": "b30bf53de9f6ae5ca59259fd695566bce692d422201c222ff136ab3193f16301e055b1030ce46a1981f439105b3a96e2",
    "payNonce": "a7b23fc462594028",
    "difficulty": "0000ffffffffffffff8000000000000000000000000000000000000000000000",
    "submittedNonce": "00000001a67fa973",
    "proofStatus": "Accepted"
}

// Cheking status while pending
{
  "status": "Verified"
}

// Cheking status once confirmed
{
  "status": "Confirmed"
}
```
{% endcodetab %}
{% endcodetabs %}

## Issue more

After an asset is registered, users can issue more bitmarks with a permanent reference to the corresponding asset record. Those issuance transactions need to be paid to be confirmed on the Blockchain.

* SDK users pay for the issuance transactions using the SDK credit system
* CLI users pay for the issuance transactions by sending BTC or LTC to the indicated address.

### Using the SDK

{% codetabs %}
{% codetab JS %}
```javascript
//import the issuer account
let issuer = Account.fromSeed("your_account_seed");

// Build and sign the bitmark issuance request
let issueParams = sdk.Bitmark.newIssuanceParams(assetId, 10);
issueParams.sign(issuer);

// Submit the issue request
let bitmarks = (await sdk.Bitmark.issue(issueParams)).bitmarks;
```
{% endcodetab %}
{% codetab Swift %}
```swift
//import the issuer account
issuer = Account(fromSeed:"your_account_seed");

// Build and sign the bitmark issuance request
var params = try Bitmark.newIssuanceParams(assetId: assetId,
                                            quantity: 10)
try params.sign(issuer)

// Submit the issue request
let bitmarkIds = try Bitmark.issue(params)
```
{% endcodetab %}
{% codetab Java %}
```java
//import the issuer account
Account issuer = Account.fromSeed("your_account_seed");

// Build and sign the bitmark issuance request
IssuanceParams params = new IssuanceParams(assetId, 10);
params.sign(issuer.getKeyPair());

// Submit the issue request
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
//import the issuer account
issuer, err := account.FromSeed("your_account_seed");

// Build and sign the bitmark issuance request
params := bitmark.NewIssuanceParams(assetID, 10)
params.Sign(issuer)

// Submit the issue request
bitmarkIDs, err := bitmark.Issue(params)
```
{% endcodetab %}
{% endcodetabs %} 

### Using the CLI

{% codetabs %}
{% codetab Command %}
```sh
# Issue more bitmarks on an existing asset
$ bitmark-cli -n <network> -i <identity> create -a '<asset name>' -m '<asset metadata>' -f <asset fingerprint> -q 10

# Verify the status of the issuance transaction
$ bitmark-cli -n <network> status -t <txid>

# Pay by BTC
$ bitmark-wallet --conf <Bitmark-Wallet config file> btc --<btc network> sendmany --hex-data '<payId>' '<btc address>,<btc amount in satoshi>'

# OR Pay by LTC
$ bitmark-wallet --conf <Bitmark-Wallet config file> ltc --<ltc network> sendmany --hex-data '<payId>' '<ltc address>,<ltc amount in photon>'

```
{% endcodetab %}
{% codetab Example %}
```sh
# Issue more bitmarks on an existing asset
$ bitmark-cli -n testing -i first create -a 'asset_name' -m 'From\u0000CLI\u0000desc\u0000example' -f 0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500 -q 10

# Verify the status of the issuance transaction
$ bitmark-cli -n testing status -t b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23

# Pay by BTC
$ bitmark-wallet --conf <Bitmark-Wallet config file> btc --<btc network> sendmany --hex-data '<payId>' '<btc address>,<btc amount in satoshi>'

# OR Pay by LTC
$ bitmark-wallet --conf <Bitmark-Wallet config file> ltc --<ltc network> sendmany --hex-data '<payId>' '<ltc address>,<ltc amount in photon>'

```
{% endcodetab %}
{% codetab Output %}
```json
// Computing asset hash
{
    "file_name": "filename.test",
    "fingerprint":"0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f799c7527859361f1694acef106d5131a96641eae524e1c323500"
}

//Registering the asset from its hash
{
    "assetId": "dac17bef505f7a5acf890a1d0f232b7d847f1e951cf1f5b880de13253a10df43cdbcab553e08050808e0b3fdfd2581a798dcdf9cedbbddf4476ead14caa612d3",
    "issueIds": [
        "b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23"
    ],
    "payId": "b30bf53de9f6ae5ca59259fd695566bce692d422201c222ff136ab3193f16301e055b1030ce46a1981f439105b3a96e2",
    "payNonce": "a7b23fc462594028",
    "difficulty": "0000ffffffffffffff8000000000000000000000000000000000000000000000",
    "submittedNonce": "00000001a67fa973",
    "proofStatus": "Accepted"
}

// Cheking status before payment
{
  "status": "Pending"
}

//Payment command's output
{
    "txId": "ca94ae188ba8bfdc42e026950c5e13a2f1082dae484a45c5dc29217ac0c9a23f",
    "rawTx": "0100000001b76a37054a086c5bd68afd61914bb4badc78c9e7ef59e6b692777cc18063632d020000006b483045022100db6f27ec3e1e59c34887f262217d5ff819947c561f0ecd11034ba8b32dbdc87002203ef82d80be8e43434eb16e22248e4533a1d3c2831e19802ce55a308604d76f3c012103b45a55c3e48209581d63ba5ceea9a0e94ae49e18056d85a6dadec535dbe237a2ffffffff03400d0300000000001976a914d2ebb7b259fb7410dca19b707c4091195d818ac488ac8091e305000000001976a9142d477753d17099534f9249b54cda36081d4e5eba88ac0000000000000000326a30d819cff364b9211093fe09c2b462bdd05154472a72fac91a882a8f1129674dc92ac5d2724c8d26b16d414de8fbc5c62e00000000"
}

// Cheking status while pending
{
  "status": "Verified"
}

// Cheking status once confirmed
{
  "status": "Confirmed"
}
```
{% endcodetab %}
{% endcodetabs %}

## Explore the transactions using the Registry website

Userse can explore all of the transactions on the Bitmark blockchain using the Bitmark Registry web application:

* For transactions on the Bitmark livenet blockchain: https://registry.bitmark.com

* For transactions on the Bitmark testnet blockchain: https://registry.test.bitmark.com

## References

* [CLI command reference](cli/cli-command-reference.md)
* [CLI quick setup](cli/cli-quick-setup.md)
