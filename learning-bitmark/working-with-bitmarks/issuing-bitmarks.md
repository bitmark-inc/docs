# Registering properties on the Bitmark blockchain

The following records are required to register a property on the Bitmark blockchain

* *Asset Record* - contructed by the Asset Registration process

* *Issue Records* - contructed by the Bitmark Issuance process.

<br>
<br>
## Registering properties using Bitmark App

* Download and install the [Android](https://apps.apple.com/us/app/bitmark-property-registry/id1429427796) or [iOS](https://apps.apple.com/us/app/bitmark-property-registry/id1429427796) Bitmark App

* Create a Bitmark Account

* Go to Properties screen

* Tap on the **+** icon

* Select a file or photo as the expected asset

* Fill in the required fields

* Tap **ISSUE** button

As tapping on the **ISSUE** button, the Bitmark app submits the requests of asset registration and bitmark issuance to the Bitmark blockchain. It will takes several minutes for the bitmarks to be confirmed on the blockchain.

* [Verify bitmark transactions](https://github.com/bitmark-inc/docs/).

<br>
<br>
## Registering properties using Bitmark SDK

In this section we are using the example of **Bitmark JS SDK** to build and submit the Asset Registration and Bitmark Issuance requests.<br>
For further functions and other languages, please look at the [Bitmark SDK](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-sdk/bitmark-sdk-document.md) section.

* Install Bitmark JS SDK

    `npm install bitmark-sdk`

* Initialize the SDK configuration

    ```
    const sdk = require('bitmark-sdk');

    const config = {
        API_token: "api-token",
        network: "testnet"
    };

    sdk.init(config);
    ```

* Create a new Bitmark account:

    `let account = new sdk.Account();`

* Register an asset:

    ```    
    let name = "Example asset";
    let metadata = {"Example key":"Example alue"};

    let params = sdk.Asset.newRegistrationParams(name, metadata);
    await params.setFingerprint(filepath);
    params.sign(account);

    let assets = (await sdk.Asset.register(params)).assets;

    let assetId = assets[0].id;
    ```

* Issue the first bitmark 

    ```
    let issueParams = sdk.Bitmark.newIssuanceParams(assetId, 1);
    issueParams.sign(account);

    let bitmarks = (await sdk.Bitmark.issue(issueParams)).bitmarks;

    let bitmarkId = bitmarks[0].id;
    ```

* [Verify bitmark transactions](https://github.com/bitmark-inc/docs/).


<br>
<br>
## Registering properties using Bitmark-CLI 

* Use Bitmark-CLI to create a Bitmark account - refer [Creating Bitmark Account](http://)

* Compute the asset's fingerprint

    `$bitmark-cli --network=testing fingerprint -f filename`

    Example Output

    ```
    {
        "file_name": "filename.test",
        "fingerprint": "0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500"
    }
    ```

* Issue the first bitmark

    `bitmark-cli --network=testing --identity=first create -a 'Example asset' -m 'Key1\u0000Value1\u0000Key2\u0000Value2' -f 0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500 -z`

    Example output:

    ```
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
    ```

* [Verify bitmark transactions](https://github.com/bitmark-inc/docs/).







