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
* [Install the SDK](sdk/getting-started.md#installing-sdk-packages)
* [Acquire an API token](sdk/getting-started.md#acquiring-an-api-token)

**Using the CLI**
* [Install the CLI along with the bitmarkd](run-a-node.md)
* [Install and configure the Bitmark Wallet](cli/cli-payment.md#installing-and-configuring-the-bitmark-wallet)

## Issue the first bitmark

The first step to create a digital property is to register assets 

* Each asset can be described by name and metadata (both optional), and can be uniquely identified by its fingerprint. 
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

// Create a Bitmark account
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

// Create a Bitmark account
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
$ bitmark-cli -i IDENTITY -n <local|testing|bitmark> add -d 'DESCRIPTION OF IDENTITY' --new

# Compute the asset hash
$ bitmark-cli -n <local|testing|bitmark> fingerprint -f <file>

# register asset along with issuing the first bitmark
$ bitmark-cli -n <local|testing|bitmark> -i <identity> create -a '<asset name>' -m '<asset metadata>' -f <asset fingerprint> -z

# Verify the status of the issuance transaction
$ bitmark-cli -n <local|testing|bitmark> status -t <txid>

```
{% endcodetab %}
{% codetab Example %}
```sh
# Create a Bitmark Account as the Issuer
bitmark-cli -n testing -i first add -d 'first' --new

#  Compute file hash
$ bitmark-cli -n testing fingerprint -f test.txt

# Issue the first bitmark of the asset
$ bitmark-cli -n testing -i first create -a 'asset_name' -m 'From\u0000CLI\u0000desc\u0000example' -f 0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500 -z

# Verify the status of the issuance transaction
$ bitmark-cli -n testing status -t 45a3e08658db810d7fda4c34a852f3707bc8e4518571c8c8a79835d0a9bb3834
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
    "45a3e08658db810d7fda4c34a852f3707bc8e4518571c8c8a79835d0a9bb3834"
  ],
  "payId": "05943784313be02e7f1823f398f82bccf803933863804a46c42119ad2a8d1f85476d2211a1079acb5cebe6682daf7168",
  "payNonce": "8ae68bb87c4a926b",
  "difficulty": "0000ffffffffffffff8000000000000000000000000000000000000000000000",
  "submittedNonce": "0000000125ef307e",
  "proofStatus": "Accepted"
}

// Checking status
{
  "status": "Verified"
}

// After about 2 minutes
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
$ bitmark-cli -n <local|testing|bitmark> -i <identity> create -a '<asset name>' -m '<asset metadata>' -f <asset fingerprint> -q 10

# Verify the status of the issuance transaction
$ bitmark-cli -n <local|testing|bitmark> status -t <txid>

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
$ bitmark-cli -n testing status -t 742fdff03ead89375b95d0c3e834ccaf5d6446b8dd4897cd6757e78317384150

# Pay by BTC
$ bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf btc --testnet sendmany --hex-data '35b336aa5dbd78a6dd14f2dff528384bb7d0066125facf898b31a942e76d74626c083b3e3f5ba07a579924604dfd3a56' 'msxN7C7cRNgbgyUzt3EcvrpmWXc59sZVN4,100000'

# OR Pay by LTC
$ bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf ltc --testnet sendmany --hex-data '35b336aa5dbd78a6dd14f2dff528384bb7d0066125facf898b31a942e76d74626c083b3e3f5ba07a579924604dfd3a56' 'mjPkDNakVA4w4hJZ6WF7p8yKUV2merhyCM,1000000'

# Verify the status of the issuance transaction
$ bitmark-cli -n testing status -t 742fdff03ead89375b95d0c3e834ccaf5d6446b8dd4897cd6757e78317384150
```
{% endcodetab %}
{% codetab Output %}
```json
// Issue more bitmarks on an existing asset
{
  "assetId": "dac17bef505f7a5acf890a1d0f232b7d847f1e951cf1f5b880de13253a10df43cdbcab553e08050808e0b3fdfd2581a798dcdf9cedbbddf4476ead14caa612d3",
  "issueIds": [
    "742fdff03ead89375b95d0c3e834ccaf5d6446b8dd4897cd6757e78317384150",
    "8babb6641dfd8a2eadd41b2cd46dfa43e035551b8d23b34eb18fde8895b43dec",
    "6b4316c2316f7894fca0ab3f5a4893bcb7fd84d4812ec11b0f7f4090b2185346",
    "f0ce573b8a0c73422f76aa367f64286879377af5d4f8e60da1f92430627be6e0",
    "eea9b090c24cb3c370583d961a7aff8bdbb4fb9ad0787101189ab96abd263403",
    "450d295025b79fb0e125bcb41ef1846301c366d51811de1f3690e623576443c9",
    "e1d6e3e54fa0f23d1fa76d9514018ec2a6b686d91af82e370edd73597c99b7e2",
    "f549830586b81e08048d8ecf0277b2e3d2ac27b0759d86d94e630dd9754d4e41",
    "398fd9d41ac2163f268584b4a6a050b14bdab62592534d102514e410b9d34076",
    "1f895b7dcd08cd7738f7cb22165b6a3c133ab04885280d9e12799f967e6300c6"
  ],
  "payId": "35b336aa5dbd78a6dd14f2dff528384bb7d0066125facf898b31a942e76d74626c083b3e3f5ba07a579924604dfd3a56",
  "payNonce": "0000000000000000",
  "difficulty": "",
  "submittedNonce": "",
  "proofStatus": "NotFound",
  "payments": {
    "BTC": [
      {
        "currency": "BTC",
        "address": "msxN7C7cRNgbgyUzt3EcvrpmWXc59sZVN4",
        "amount": "100000"
      }
    ],
    "LTC": [
      {
        "currency": "LTC",
        "address": "mjPkDNakVA4w4hJZ6WF7p8yKUV2merhyCM",
        "amount": "1000000"
      }
    ]
  },
  "commands": {
    "BTC": "bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf btc --testnet sendmany --hex-data '35b336aa5dbd78a6dd14f2dff528384bb7d0066125facf898b31a942e76d74626c083b3e3f5ba07a579924604dfd3a56' 'msxN7C7cRNgbgyUzt3EcvrpmWXc59sZVN4,100000'",
    "LTC": "bitmark-wallet --conf ${XDG_CONFIG_HOME}/bitmark-wallet/test/test-bitmark-wallet.conf ltc --testnet sendmany --hex-data '35b336aa5dbd78a6dd14f2dff528384bb7d0066125facf898b31a942e76d74626c083b3e3f5ba07a579924604dfd3a56' 'mjPkDNakVA4w4hJZ6WF7p8yKUV2merhyCM,1000000'"
  }
}

// Cheking status before payment
{
  "status": "Pending"
}

//Payment command's output
{
  "txId": "69a1a4810d0b703fb855397334bb3c04a0dc90e3c2c5cfa1d64b6c100f5ffe7d", 
  "rawTx": "0100000001c2de9f79c6d5c112b5b8c2979c7d9ec18a5712e995c6eaafc44a8a2ac3852c23010000006a473044022063e3135e76403d4d07ba24f9053ca59cd56c9140ff11c49796e7dd6f08b9912d0220637f83fb58754ad5c9be816af3af09fbadb47f60f70627b2b8e7732f6adf8e700121031202a8f1cb428470d172d93d71d12bf3be8aa54b30426b185a0938cd966bef94ffffffff03a0860100000000001976a914886fc94c1420d404103f32d1c812513857f6ecc988ac4042fc94000000001976a914ca0d5ec57c5eae9b5d362f59ef7ec7e1b2e8251d88ac0000000000000000326a3035b336aa5dbd78a6dd14f2dff528384bb7d0066125facf898b31a942e76d74626c083b3e3f5ba07a579924604dfd3a5600000000"
}

// Cheking status after the payment
{
  "status": "Verified"
}

// Cheking status after about 2 minutes
{
  "status": "Confirmed"
}
```
{% endcodetab %}
{% endcodetabs %}

## Explore the transactions using the Registry website

Users can explore all of the transactions on the Bitmark blockchain using the Bitmark Registry website:

* [Explore transactions on the Bitmark blockchain](https://registry.bitmark.com)

* [Explore transactions on the Bitmark testnet blockchain](https://registry.test.bitmark.com)

## References

CLI
  * [CLI command reference](cli/cli-command-reference.md)
  * [CLI quick setup](cli/cli-quick-setup.md)

<br>

SDK
  * [SDK Getting Started](sdk/getting-started.md)
  * [SDK Account](sdk/account.md)
  * [SDK Action](sdk/action.md)
  * [SDK Query](sdk/query.md)
  * [SDK Migration](sdk/migration.md)
  * [SDK Store Seed](sdk/store-seed.md)
  * [SDK Web Socket](sdk/websocket.md)