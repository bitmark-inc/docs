# Bitmark Account

Any user interacting with the Bitmark Property System requires a Bitmark Account. It can be created using the [Bitmark App](##Creating Bitmark Account using Bitmark App), the [Bitmark SDK](##Creating Bitmark Account using Bitmark SDK), or the [Bitmark CLI](##Creating Bitmark Account using Bitmark-CLI).

After creating the Account, a user will often want to recover the seed (which is the private key that can be used to control the Account) and the recovery phrase (which is a set of 12 mnemonic words that can be used to regenerate the seed).

<br>
<br>
## Bitmark Account Number

Property owners in Bitmark system are identified by their Ed25519 public keys. These public keys are represented by the Bitmark account numbers, which are in based58 format.

> * **Example:** Bitmark Account Number on [Livenet](https://registry.bitmark.com/account/bqSUHTVRYnrUPBEU48riv9UwDmdRnHm9Mf9LWYuYEa7JKtqgKw){:target="_blank"}
> 
>       `bqSUHTVRYnrUPBEU48riv9UwDmdRnHm9Mf9LWYuYEa7JKtqgKw`
>          
> * **Example:** Bitmark Account Number on [Testnet](https://registry.test.bitmark.com/account/fABCJxXc8aYGoj1yLLXmsGdWEo1Y5cZE9Ko5DrHhy4HvgGYMAu/owned){:target="_blank"}
> 
>       `fABCJxXc8aYGoj1yLLXmsGdWEo1Y5cZE9Ko5DrHhy4HvgGYMAu`

<br>
<br>
## Creating Bitmark Account using the Bitmark App

Bitmark App is a simple mobile app which allows anyone to protect their legal rights to their data and other digital assets by registering them as properties on the Bitmark blockchain.

<br>
Here are the steps to create a new Bitmark Account using the Bitmark App:

* Download and install the [Android](https://apps.apple.com/us/app/bitmark-property-registry/id1429427796){:target="_blank"} or [iOS](https://apps.apple.com/us/app/bitmark-property-registry/id1429427796){:target="_blank"} Bitmark App

* Open the app

* Start creating a new Bitmark Account by tapping the **Create New Account** option
    
    > There are options to enable Touch/Face ID and Notification while creating a new account 

    <div style="background-color: #efefef; text-align: center;">
        <img src="images/CreateAccount_0.png" alt="Create New Account option" title="Create New Account option" width="250" style="padding: 20px" />
        <img src="images/CreateAccount_1.png" alt="Touch/Face ID option" title="Touch/Face ID option" width="250" style="padding: 20px" /> 
        <img src="images/CreateAccount_3.png" alt="Notification option" title="Notification option" width="250" style="padding: 20px" />
    </div>

    <br>

* Check for the Account Number by accessing **Account > SETTINGS**

    > The Bitmark App allows users to
 
    > * **Copy** the Account Number to clipboard directly by tapping on it 

    > * **Display** the Account Number as a QR Code by tapping on the QR Code icon.

    <div style="background-color: #efefef; text-align: center;">
        <img src="images/AccountMenu.png" alt="Account Menu" title="Account Menu" width="250" style="padding: 20px" />
        <img src="images/AccountSettings.png" alt="Account Settings" title="Account Settings" width="250" style="padding: 20px" />
    </div>

    <br>

* Backup the Recovery Phrase by selecting **Account > SETTINGS > WRITE DOWN RECOVERY PHRASE**

    <div style="background-color: #efefef; text-align: center;">
        <img src="images/RecoveryPhrase_0.png" alt="Write down Recovery Phrase option" title="Write down Recovery Phrase option" width="250" style="padding: 20px" />
        <img src="images/RecoveryPhrase_1.png" alt="Write down Recovery Phrase" title="Write down Recovery Phrase" width="250" style="padding: 20px" />
        <img src="images/RecoveryPhrase_2.png" alt="Recovery Phrase" title="Recovery Phrase" width="250" style="padding: 20px" />
    </div>

<br>
<br>
## Creating Bitmark Account using the Bitmark SDK

The Bitmark SDK is a collection of libraries for different programming languages and mobile platforms. In addition to providing language-specific bindings to the Bitmark APIs, the SDK simplifies local key management for signing and encryption.

>In this section we introduce a very simple way to create a new Bitmark Account using **Bitmark JS SDK**.<br>
>For the detailed explanation, further, functions and other languages - Please look at the [Bitmark SDK](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-sdk/bitmark-sdk-document.md){:target="_blank"} section.

<br>

Here are the steps to install the Bitmark-SDK, initalize its configuration, then create a new Bitmark Account and export the related information:

* Install Bitmark JS SDK

    `# npm install bitmark-sdk`

* Initialize the SDK configuration

    ```
        const sdk = require('bitmark-sdk');

        const config = {
            API_token: "api-token",
            network: "testnet"
        };

        sdk.init(config);
    ```



> The SDK supports two options for the network, each requires the corresponding API tokens
> 
> * "livenet" - all the requests are submitted to the public Bitmark blockchain which is the main chain. 
> 
> * "testnet" - all the requests are submitted to the testing Bitmark blockchain which is normally used for testing and developing activities.

<br>

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
## Creating Bitmark Account using the Bitmark-CLI

Bitmark-CLI is a command line tool which allows a user to interact with the Bitmark blockchain by connecting to one or several nodes in the network. All the transactions are submitted directly to one of the connected nodes and consequently be verified by the node before be forwarded to the network.

> In this section, we introduce very simple commands to create a new Bitmark Account using the Bitmark-CLI
> For the command structures, detailed explanation, other functions - Please refer the [Bitmark-CLI](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-cli/bitmark-cli.md){:target="_blank"} section.

<br>
> The basic structure of a Bitmark-CLI command:  
>   `bitmark-cli [global-options] command [command-options]`

<br>
    
> The Bitmark-CLI determines which network the command will be sent to by the global option `--network` the following possible values
> 
>* `bitmark`:  the live network which uses live BTC or LTC to pay for the transactions.
>
>* `testing`:  a network for testing newly developed programs, it uses testnet coins to pay for transactions.
> 
>* `local`: a special case for running a regression test network on the loopback interface.

<br>

Following are the intructions to create Bitmark account with the network option as `testing`

* Install [Bitmark-CLI](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-cli/bitmark-cli.md){:target="_blank"}

* Initalize the Bitmark-CLI configuration
    ```
    # bitmark-cli --network=testing --identity=first \ 
    setup --connect=128.199.89.154:2130 --description='first user' --new
    ```

> The `setup` command is used to initialize the Bitmark-CLI config file
> 
> * It requires you to select a default user, which is done with the `--identity` option - In the command above, it creates a Bitmark Account with the identity as `first` and the description as `first user`
> 
> * The `--connection` option defines the Bitmark node which the Bitmark-CLI connects to - The connected node's chain is also the chain that the Bitmark-CLI works on.

<br>

*  Add an additional Bitmark account
    ```
    # bitmark-cli --network=testing --identity=second \ 
    add --description='second user' --new
    ```

> The `add` command is to add a new user after the Bitmark-CLI configuration was initialized.

<br>

* Check the account numbers
    ```
    # bitmark-cli --network=testing list

    SK first    fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A  "first user"
    SK second   fPWWkW45o12er6oP4EveaURHXstkSXR3odWCgpaDvEvxoR3woC  "second user"
    ```


* Get the account seed and recovery phrase for an identity
    ```
    # bitmark-cli --network=testing --identity=first seed
    
    {
        "privateKey": "BQVdbCAVQ1KHv4sDSQ5d874BfZYmLeeJveNGXThxU4WKh5K39o6eEVqoBZFKbJWHiJgkyYThnBFdfF9bgSGmhyDLsk7oR9",
        "seed": "9J87ApGrXzDitFk8eviHf31RNXbTcjW8S",
        "description": "first user",
        "name": "first",
        "account": "fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A",
        "recovery_phrase": "lamp between sponsor butter lawn ski venture autumn anger corn bullet catalog"
    }
    ```

<br>

>**NOTE:** 
>
>* The account creation commands require users to provide and confirm password
>
>* All the identity-required commands ask for the account password. 

