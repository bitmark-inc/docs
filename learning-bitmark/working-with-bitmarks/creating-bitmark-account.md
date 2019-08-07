# Creating Bitmark account

<br>
<br>
## Bitmark account number

Property owners in Bitmark system are identified by their Ed25519 public keys. Those public keys are represented by the Bitmark account numbers which are in based58 endcoded format.

* Account number - livenet example:

    `bqSUHTVRYnrUPBEU48riv9UwDmdRnHm9Mf9LWYuYEa7JKtqgKw`

* Account number - testnet example:

    `fABCJxXc8aYGoj1yLLXmsGdWEo1Y5cZE9Ko5DrHhy4HvgGYMAu`

<br>
<br>
## Creating Bitmark account using Bitmark App

* Download and install the [Android](https://apps.apple.com/us/app/bitmark-property-registry/id1429427796) or [iOS](https://apps.apple.com/us/app/bitmark-property-registry/id1429427796) Bitmark App

* Open the app

* Follow the instructions to create a new account

* Check for the account number at Account > Settings screen

* Backup the recovery phrase via Account > Settings screen > Write down recovery phrase

<br>
<br>
## Creating Bitmark account using Bitmark SDK

In this section we are using the example of **Bitmark JS SDK** to create a new Bitmark account.<br>
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

* Get the Account number:

    `let account_number = account.getAccountNumber();`

* Get the Account seed:

    `let seed = account.getSeed();`

* Get the Account recovery phrase:

    `let phrase = account.getRecoveryPhrase();`

<br>
<br>
## Creating Bitmark account using Bitmark-CLI

Following are the intructions to create Bitmark account on the testnet blockchain

* Install [Bitmark-CLI](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-cli/bitmark-cli.md)

* Create a new Bitmark account while initalizing the Bitmark-CLI configuration

    `$bitmark-cli --network=testing --identity=first setup --connect=128.199.89.154:2130 --description='first user' --new`

It creates a Bitmark account on the Bitmark testnet blockchain with the identity saved in the Bitmark-CLI config file as "first".

*  Add another Bitmark account

    `$bitmark-cli --network=testing --identity=second add --description='second user' --new`


* Check the account numbers

    `$bitmark-cli --network=testing list`

    Example output:
    ```
    SK first    fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A  "first user"
    SK second   fPWWkW45o12er6oP4EveaURHXstkSXR3odWCgpaDvEvxoR3woC  "second user"
    ```

* Get account seed and recovery phrase by identity

    `bitmark-cli --network=testing --identity=first seed`
    
    Example output
    ```
    {
        "privateKey": "BQVdbCAVQ1KHv4sDSQ5d874BfZYmLeeJveNGXThxU4WKh5K39o6eEVqoBZFKbJWHiJgkyYThnBFdfF9bgSGmhyDLsk7oR9",
        "seed": "9J87ApGrXzDitFk8eviHf31RNXbTcjW8S",
        "description": "first user",
        "name": "first",
        "account": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
        "recovery_phrase": "lamp between sponsor butter lawn ski venture autumn anger corn bullet catalog"
    }
    ```

**NOTE:** 

* The account creation commands require users to provide and confirm password

* All the identity-required commands ask for the account password. 


