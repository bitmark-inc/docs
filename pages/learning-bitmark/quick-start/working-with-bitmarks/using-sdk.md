---
title: Using the SDK
keywords: bitmark, account, transaction
last_updated: 
sidebar: mydoc_sidebar
permalink: /learning-bitmark/quick-start/working-with-bitmarks/using-sdk
folder: learning-bitmark/quick-start/working-with-bitmarks
---

# Using the SDK

This section introduces a simple way to create a new Bitmark Account and execute bitmark transactions using the JS SDK. For a detailed explanation, further functions, and other languages please consult the [Bitmark SDK](../../../../bitmark-references/bitmark-sdk/bitmark-sdk-document.md) documents.

## Creating a Bitmark Account

To initialize the Bitmark JS SDK, create a Bitmark Account, and export the related information:

* Install the Bitmark JS SDK

    `# npm install bitmark-sdk`

* Initialize the SDK configuration

    ```js
        const sdk = require('bitmark-sdk');

        const config = {
            API_token: "api-token",
            network: "testnet"
        };

        sdk.init(config);
    ```

    > The SDK supports two options for the network, each requiring a corresponding API tokens:
    > 
    > * "livenet" - all requests are submitted to the public Bitmark blockchain, which is the main chain. 
    > 
    > * "testnet" - all  requests are submitted to the testing Bitmark blockchain, which is normally used for testing and development activities.

* Create a new Bitmark account

    ```js
    let account = new sdk.Account();
    ```

* Retrieve the Account number

    ```js
    let account_number = account.getAccountNumber();
    ```

* Retrieve the Account seed
    ```js
    let seed = account.getSeed();
    ```
* Retrieve the Account recovery phrase
    ```js
    let phrase = account.getRecoveryPhrase();
    ```

## Registering Bitmark Certificates

To register a new property using the Bitmark JS SDK:

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
## Transferring bitmarks using the Bitmark SDK

To transfer a Bitmark Certificate using the Bitmark JS SDK:

* Submit a transfer transaction

    ```js
        let transferParams = Bitmark.newTransferParams(recipientAccount);
        await transferParams.fromBitmark(bitmarkid);
        transferParams.sign(sender);

        let txs = (await Bitmark.transfer(transferParams)).txs;
        let txId = txs[0].id;
    ```

* Verify the transfer transaction

    ```js
        await Transaction.get(txId);
    ```

## Exploring bitmark transactions using the Bitmark Registry website

Userse can explore all of the transactions on the Bitmark blockchain using the Bitmark Registry web application:

* For transactions on the Bitmark livenet blockchain: https://registry.bitmark.com

* For transactions on the Bitmark testnet blockchain: https://registry.test.bitmark.com
