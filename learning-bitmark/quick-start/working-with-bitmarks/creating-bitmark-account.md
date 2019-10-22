# Creating a Bitmark Account

Any user interacting with the Bitmark Property System requires a Bitmark Account. It can be created using the [Bitmark App](#creating-a-bitmark-account-using-the-bitmark-app), the [Bitmark SDK](#creating-a-bitmark-account-using-the-bitmark-sdk), or the [Bitmark-CLI](#creating-a-bitmark-account-using-the-bitmark-cli).

After creating an Account, a user will often want to recover the seed (which is the private key that can be used to control the Account) and the recovery phrase (which is a set of 12 mnemonic words that can be used to regenerate the seed).

### Bitmark Account Number

Property owners in Bitmark system are identified by their Ed25519 public keys. These public keys are represented in the Bitmark Property System by Bitmark Account Numbers, which encode the Ed25519 key in based58 format.

*Example — Bitmark Account Number on [Livenet](https://registry.bitmark.com/account/bqSUHTVRYnrUPBEU48riv9UwDmdRnHm9Mf9LWYuYEa7JKtqgKw):*
>       `bqSUHTVRYnrUPBEU48riv9UwDmdRnHm9Mf9LWYuYEa7JKtqgKw`
         
       
*Example — Bitmark Account Number on [Testnet](https://registry.test.bitmark.com/account/fABCJxXc8aYGoj1yLLXmsGdWEo1Y5cZE9Ko5DrHhy4HvgGYMAu/owned):*
>       `fABCJxXc8aYGoj1yLLXmsGdWEo1Y5cZE9Ko5DrHhy4HvgGYMAu`

## Creating a Bitmark Account using the Bitmark App

To create a Bitmark Account using the Bitmark App:

* Download and install the [Android](https://play.google.com/store/apps/details?id=com.bitmark.registry) or [iOS](https://apps.apple.com/us/app/bitmark-property-registry/id1429427796) Bitmark App

* Open the App

* Tap the **Create New Account** option
    
    > There are options to enable Touch/Face ID and Notification while creating a new account 

    <div style="background-color: #efefef; text-align: center;">
        <img src="images/CreateAccount_0.png" alt="Create New Account option" title="Create New Account option" width="250" style="padding: 20px" />
        <img src="images/CreateAccount_1.png" alt="Touch/Face ID option" title="Touch/Face ID option" width="250" style="padding: 20px" /> 
        <img src="images/CreateAccount_3.png" alt="Notification option" title="Notification option" width="250" style="padding: 20px" />
    </div>

    <br>

* Look up the Account Number by accessing **Account > SETTINGS**; record it

    > The Bitmark App allows users to
    >
    > * **Copy** the Account Number to clipboard directly by tapping on it; or
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

## Creating a Bitmark Account using the Bitmark SDK

This section introduces a simple way to create a new Bitmark Account using the Bitmark JS SDK. For a detailed explanation, further functions, and other languages please consult the [Bitmark SDK](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-sdk/bitmark-sdk-document.md) documents.

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

* Create a new Bitmark account:

    ```js
    let account = new sdk.Account();
    ```

* Retrieve the Account number:

    ```js
    let account_number = account.getAccountNumber();
    ```

* Retrieve the Account seed:
    ```js
    let seed = account.getSeed();
    ```
* Retrieve the Account recovery phrase:
    ```js
    let phrase = account.getRecoveryPhrase();
    ```

## Creating a Bitmark Account using the Bitmark-CLI

This section introduces simple commands to create a new Bitmark Account using the Bitmark-CLI. For the command structures, detailed explanations, and other functions please refer the [Bitmark-CLI](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-cli/bitmark-cli.md) documents.

### The Basics of Bitmark-CLI

All Bitmark-CLI commands follow the same basic structure:

`$ bitmark-cli [global-options] command [command-options]`
    
You will need to send the Bitmark-CLI the global option `--network` (abbreviation: `-n`) to identify the network that you are sending the command to.

**Network Options:**
* `bitmark`:  the live network, which uses live BTC or LTC to pay for the transactions.
* `testing`:  a network for testing newly developed programs, which uses testnet coins to pay for transactions.
* `local`: a special case for running a regression test network on the loopback interface.

### Creating the Account

To create a Bitmark Account using the Bitmark App:

* Install [Bitmark-CLI](https://github.com/bitmark-inc/docs/blob/master/bitmark-references/bitmark-cli/bitmark-cli.md)

* Initialize the Bitmark-CLI configuration

    ```shell
    $ bitmark-cli -n <network> -i <identity> \
    setup -c <node>:2130 -d '<description>' -n
    ```

    >The `setup` command is used to initialize the Bitmark-CLI config file.
    >
    > **Global Options:**
    >* `network` - The network to which the command is sent.
    >* `identity` - The identity of the Bitmark-CLI user.
    >
    > **Command Options:**
    >* `node` - The Bitmark node to which the Bitmark-CLI connects and submits its transactions.
    >* `description` - The identity’s description. 
    >* `-n` (abbr. of --new) - Indicates that a new account is being created.
    
    *Example:*
 
    ```shell
    $ bitmark-cli -n testing -i first \
    setup -c 128.199.89.154:2130 -d 'first user' -n
    ```
    > This command creates a user on the testing network using the node 128.199.89.154:2130 with the user having an identity of "first" and a description of "first user".

*  Add an additional Bitmark account
    ```shell
    $ bitmark-cli -n <network> -i <identity> \
    add -d '<description>' -n
    ```

    > The `add` command adds a new user after the Bitmark-CLI configuration was initialized. 
    > The command options have the same meanings as in the `setup` command.
    
    *Example:*  
    ```shell
    $ bitmark-cli -n testing -i second \
    add -d 'second user' -n
    ```

* Check the account numbers
    ```shell
    $ bitmark-cli -n <network> list
    ```

    > The `list` command is lists all the users of the Bitmark-CLI.
    
    *Example:*

    ```shell
    $ bitmark-cli -n testing list
    ```
    ```
    SK first    fUuNhZ6CC4YxUkQB99nuLnUiEevEuwdCoYszJ9Y5uUjp8oiA3A  "first user"
    SK second   fPWWkW45o12er6oP4EveaURHXstkSXR3odWCgpaDvEvxoR3woC  "second user"
    ```


* Get the account seed and recovery phrase for an identity
    ```shell
    $ bitmark-cli -n <network> -i <identity> seed
    ```

    > The `seed` command prints out all the information about a Bitmark-CLI user. 
    
    *Example:*
 
    ```shell
    $ bitmark-cli -n testing -i first seed
    ```
    ```json
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

* The account creation commands require users to provide and confirm a password.
* All identity-required commands ask for the account password. For example, the `seed` command requires it because it outputs sensitive data.

