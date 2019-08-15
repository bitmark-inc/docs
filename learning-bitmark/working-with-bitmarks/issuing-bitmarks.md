# Registering properties on the Bitmark blockchain


In the digital age, having a copy of something (such as a photo) is sometimes confused with owning it as property. Just because someone has a copy of your photo does not mean they have the legal rights to distribute it, sell it, or other transfer ownership to someone else. The Bitmark Property System protects your rights by giving you control over your digital assets, allowing you to register provenance of property according to standards recognized by the world’s legal systems.

Your properties can be registered on the public Bitmark blockchain using the [Bitmark App](##Registering properties using Bitmark App), the [Bitmark SDK](##Registering properties using Bitmark SDK), or the [Bitmark CLI](##Registering properties using Bitmark-CLI).

The Bitmark blockchain is a public global database that stores property rights to non-fungible objects in a token-like container. Because it is a decentralized and politically-neutral system, no single entity has the ability to improperly modify property records or transactions — not even the Bitmark team. 

<br>

>The following records are required to register a property on the Bitmark blockchain
>
>* *Asset Record* - contructed by the Asset Registration process
>
>* *Issue Records* - contructed by the Bitmark Issuance process.

<br>

> **NOTE:** Any user interacting with the Bitmark Property System requires a Bitmark Account.
> Please refer [Bitmark Account](creating-bitmark-account.md){:target="_blank"} section for instructions of creating a new Bitmark Account.

<br>
<br>

## Registering properties using Bitmark App

The Bitmark app registers legal property rights on the public Bitmark blockchain for your digital assets, including personal health and social data, creative works such as art, photography, and music, and other intellectual property. These legal rights determine who owns property and what can be done with it, whether you want to keep it, sell it, or donate it.

<br>
Here are the steps to register a new property using the Bitmark app:

* On the PROPERTIES screen - Tap **CREATE FIRST PROPERTY** or **+** 

    > It opens the PROPERTIES > REGISTER screen

    <div style="background-color: #efefef; text-align: center;">
        <img src="images/RegisteringProperties_0.png" alt="Properties screen" title="Properties screen" width="250" style="padding: 20px" />
        <img src="images/RegisteringProperties_1.png" alt="Properties Register screen" title="Properties Register screen" width="250" style="padding: 20px" />
    </div>

    <br>

* Tap **PHOTOS** or **FILES** to browse the desired asset

    > It requires permission granted to access `Photos` and/or `Files`

    <div style="background-color: #efefef; text-align: center;">
        <img src="images/RegisteringProperties_2.png" alt="Grant Permission popup" title="Grant Permission popup" width="250" style="padding: 20px" />
        <img src="images/RegisteringProperties_3.png" alt="Open Photos action sheet" title="Open Photos action sheet" width="250" style="padding: 20px" />
        <img src="images/RegisteringProperties_4.png" alt="PHOTOS browsed" title="PHOTOS browsed" width="250" style="padding: 20px" />
    </div>

    <br>

* Fill in the required information

    > As soon as the desired asset is selected, the app computes the asset's fingerprint and opens REGISTER PROPERTY RIGHTS screen which allows users to provide more detailed information for the asset.

    >* Currently, the `PROPERTY NAME` and `NUMBER OF BITMARKS TO ISSUE` fields are mandatory.

    >* For each `Asset`, we are able to issue multiple `Bitmark Certificates` - defined by  `number of bitmarks` in the REGISTER PROPERTY RIGHTS screen.

    <div style="background-color: #efefef; text-align: center;">
        <img src="images/RegisteringProperties_5.png" alt="Register Property Rights screen" title="Register Property Rights screen" width="250" style="padding: 20px" />
        <img src="images/RegisteringProperties_6.png" alt="Fill in required information" title="Fill in required information" width="250" style="padding: 20px" />
    </div>

    <br>

* Tap **ISSUE** button

    >As soon as users tap **ISSUE**, the app submits both the `Asset Registration` request and `bitmarks Issuance` transactions to the Bitmark network. It would takes few seconds for the submission to be successful. After that the properties will be added to the PROPERTIES > YOURS screen.
    > 
    > **NOTE:** It will takes several minutes for the transactions to be confirmed on the Bitmark blockchain after submitted. 

<div style="background-color: #efefef; text-align: center;">
    <img src="images/RegisteringProperties_7.png" alt="Submitting transaction" title="Submitting transactions" width="250" style="padding: 20px" />
    <img src="images/RegisteringProperties_8.png" alt="Submission succeeded" title="Submission succeeded" width="250" style="padding: 20px" />
    <img src="images/RegisteringProperties_9.png" alt="Properties added" title="Properties added" width="250" style="padding: 20px" />
</div>

<br>

* [Verify](https://github.com/bitmark-inc/docs/) bitmark transactions.


<br>
<br>
## Registering properties using Bitmark SDK

<br>
>In this section we introduce a very simple way to register properties using **Bitmark JS SDK**.<br>
>For the detailed explanation, further, functions and other languages - Please look at the [Bitmark SDK](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-sdk/bitmark-sdk-document.md){:target="_blank"} section.

<br>
Following is the instructions to registering a property to the testing Bitmark blockchain using the Bitmark JS SDK

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

* [Verify](https://github.com/bitmark-inc/docs/){:target="_blank"} bitmark transactions.

<br>
<br>
## Registering properties using Bitmark-CLI 

> In this section, we introduce very simple commands to create a new Bitmark Account using the Bitmark-CLI
> For the command structures, detailed explanation, other functions - Please refer the [Bitmark-CLI](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-cli/bitmark-cli.md){:target="_blank"} section.

<br>
    
> The Bitmark-CLI supports three values for the network and identify it by `--network` argument
> 
>* `bitmark`:  the live network which uses live BTC or LTC to pay for the transactions.
>
>* `testing`:  a network for testing newly developed programs, it uses testnet coins to pay for transactions.
> 
>* `local`: a special case for running a regression test network on the loopback interface.

<br>

Following are the steps to registering a new property with the network option as `testing`

* Compute the asset's fingerprint

    ```
    # bitmark-cli --network=testing fingerprint -f filename

    {
        "file_name": "filename.test",
        "fingerprint": "0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500"
    }
    ```

* Issue the first bitmark

    ```
    # bitmark-cli --network=testing --identity=first create -a 'Example asset' -m 'Key1\u0000Value1\u0000Key2\u0000Value2' -f 0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500 -z

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

* * [Verify](https://github.com/bitmark-inc/docs/){:target="_blank"} bitmark transactions.







