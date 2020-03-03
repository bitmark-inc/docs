---
title: Registering Bitmark Certificates
keywords: register bitmark certificates
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/working-with-bitmarks/issuing-bitmarks
folder: learning-bitmark/quick-start/working-with-bitmarks
---

# Registering Bitmark Certificates

Assets with titles that have been publicly recorded are [more valuable](../../problem-we-are-trying-to-solve.md) than those without. They are what grant basic rights, such as the ability to resell, rent, lend, and donate the property. The Bitmark blockchain allows individuals to access these rights for digital assets by registering their titles as Bitmark Certificates. This can be done using the [Bitmark SDK](#registering-bitmark-certificates-using-the-bitmark-sdk), or the [Bitmark CLI](#registering-bitmark-certificates-using-the-bitmark-cli).

The process of registering a Bitmark Certificate for a digital asset occurs in two steps:

* Registering the asset: this creates an *Asset Record*, which is stored on the Bitmark blockchain.

* Issuing bitmarks: this creates *Issue Records* linking to the corresponding asset record, which are also stored on the Bitmark blockchain.

This process registers legal property rights on the public Bitmark blockchain for an individual's digital assets, including personal health and social data, creative works such as art, photography, and music, and other intellectual property. These legal rights determine who owns property and what can be done with it, whether the individual wants to keep it, sell it, or donate it.

## Prerequisites

Any user who want to interact with the Bitmark Property System must have a Bitmark Account. Please refer to the [Bitmark Account](creating-bitmark-account.md) section for instructions on creating a new Bitmark Account.

## Registering Bitmark Certificates using the Bitmark SDK

To register a new property using the Bitmark JS SDK:

* [Configure the SDK and create an account](https://github.com/bitmark-inc/docs/blob/shannona-patch-working-with-bitmark/learning-bitmark/quick-start/working-with-bitmarks/creating-bitmark-account.md#creating-a-bitmark-account-using-the-bitmark-sdk)
* Register an asset

    ```js
    // Create a Bitmark Account as the Issuer
    let account = new sdk.Account();

    // Define the asset name & metadata
    let name = "Example asset";
    let metadata = {"Example key":"Example alue"};

    // Build and sign the asset registration request
    let params = sdk.Asset.newRegistrationParams(name, metadata);
    await params.setFingerprint(filepath);
    params.sign(account);

    // Send the request
    let assets = (await sdk.Asset.register(params)).assets;

    let assetId = assets[0].id;
    ```

* Issue the first Bitmark Certificate

    ```js
    // Build and sign the bitmark issuance request
    let issueParams = sdk.Bitmark.newIssuanceParams(assetId, 1);
    issueParams.sign(account);

    // Send the request
    let bitmarks = (await sdk.Bitmark.issue(issueParams)).bitmarks;

    let bitmarkId = bitmarks[0].id;
    ```

* Verify the issuance transaction by querying for the Bitmark by its `bitmarkId`

    ```js
        await Bitmark.get(bitmarkId);
    ```



## Registering Bitmark Certificates using the Bitmark CLI

See [The Basics of Bitmark CLI](https://github.com/bitmark-inc/docs/blob/shannona-patch-working-with-bitmark/learning-bitmark/quick-start/working-with-bitmarks/creating-bitmark-account.md#creating-a-bitmark-account-using-the-bitmark-cli) for more information on the interface.

To register a new property using the Bitmark CLI:

* Compute the hash of an asset

    ```shell
    $ bitmark-cli -n <network> \
    fingerprint -f <file>
    ```

    > The `fingerprint` command computes the hash of a file
    >
    > **Command Options:**
    > * `file` - The file from which the hash is computed.

    *Example:*

    ```shell
    $ bitmark-cli -n testing \
    fingerprint -f test.txt
    ```
    ```json
    {
        "file_name": "filename.test",
        "fingerprint": "0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500"
    }
    ```

* Issue the first Bitmark Certificate

    ```shell
    $ bitmark-cli -n <network> -i <identity> \
    create -a '<asset name>' \
    -m '<asset metadata>' \
    -f <asset fingerprint> \
    -z
    ```

    > The `create` command registers an asset from a fingerprint *and* issues the corresponding bitmarks
    >
    > **Global Options:**
    >* `identity` - The identity of the registrant's Bitmark Account, which is stored in the Bitmark CLI config file. 
    >
    > **Command Options:**
    >* `asset name` - The `name` field in the asset record.
    >
    >* `asset metadata` - The `metadata` field in the asset record.
    >
    >* `asset fingerprint` - The hash of the asset.
    >
    >* `-z` option - This is the first Bitmark issued for the asset.

    *Example:*

    ```shell
    $ bitmark-cli -n testing -i first \
    create -a 'Example asset' \
    -m 'Key1\u0000Value1\u0000Key2\u0000Value2' \
    -f 0122aa7d05ce9d324feca37780eeeeb7af8611eefb61cfe42bf9f8127071b481520b529e06c9f0799c7527859361f1694acef106d5131a96641eae524e1c323500 \
    -z
    ```
    ```json
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

* Verify the status of the Bitmark issuance transaction

    ```shell
    $ bitmark-cli -n <network>\
      status -t <txid>
    ```

    > The `status` commands checks if a Bitmark has been issued
    >
    >**Command Options:**
    >* `txid` — The transaction being verified, corresponding to the `issueIds` from the `create` command
    >
    >**Returns:**
    >* `Pending` - Not paid.
    >
    >* `Verified` - Paid but not confirmed on the blockchain.
    >
    >* `Confirmed` - Confirmed on the blockchain.
    
    *Example:*

    ```shell
    $ bitmark-cli -n testing \
      status -t \
      b069f2956b828281dec040782eea3d63793ab4cf17c26f7639e95f6f3b20ba23
    ```

    ```json
    // Check right after the create command
    {
      "status": "Pending"
    }

    // Check again after some minutes
    {
      "status": "Confirmed"
    }
    ```

## Exploring Bitmark transactions using the Bitmark Registry website

Users can explore all of the transactions on the Bitmark blockchain using the Bitmark Registry web application:

* For transactions on the Bitmark livenet blockchain: https://registry.bitmark.com

* For transactions on the Bitmark testnet blockchain: https://registry.test.bitmark.com
