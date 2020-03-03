---
title: bitmark-cli Command Reference
keywords: CLI, bitmark-cli, command line interface
last_updated: 
sidebar: mydoc_sidebar
permalink: /register-and-control-data/cli/bitmark-cli-command-reference
folder: register-and-control-data/cli
---

# bitmark-cli Command Reference

## Basic Command Structure

The basic structure of `bitmark-cli` commands is:
~~~
bitmark-cli [global-options] command [command-options]
~~~

### Global Options

Global options have both long-form and single character abbreviations:

-------------------------------  ---------------------------------
`--verbose|-v`                   An option to output additional information
                                 for each command.  Most commands will
                                 output the JSON request and the response
                                 sent to the bitmarkd.

`--network|-n NETWORK`           The network the
                                 command will be sent to, from these
                                 values:
                                 * `bitmark`, the live network, which uses live BTC or LTC to pay for transactions.
                                 * `testing`, a network for testing newly developed programs, which uses testnet coins to pay for transactions.
                                 * `local`, a special case for running a regression test network on the loopback interface.

`--connection|-c NUMBER`         A
                                 connection listed in the
                                 configuration file that should be used, instead
                                 of defaulting to the first one.

`--identity|-i NAME`             An account to run commands as.
                                 See "Options: identity" for more details.

`--password|-p PASSWORD`         A password, primarily used  for regeression testing scripts. It is
                                 not recommended for normal use, as the
                                 password will be left in the command
                                 history and be viewable by process
                                 display commands such as `top` and `ps`.

`--use-agent|-u EXECUTABLE`      Access method for a password
                                 stored in a password manager. See "Options: agent program" for more details.

`--zero-agent-cache|-z`          An option to prepend a `--clear` to the argument list of
                                 the `--use-agent` command, to force
                                 the password manager to re-prompt for
                                 the password.
-------------------------------  ---------------------------------

### Options: Identity

A short mnemonic **identity** string is used to represent each Bitmark account. These identities are stored in the configuration file and contain three parts:

* The password-protected private key, used for signing transactions.
* The public Account Number (a Base58 string), used as the recipient in transfers.
* A description that holds additional text, which is never sent to blockchain.

After initial setup that first identity is normally used to sign all
transactions. However, it can be overridden by the global `--identity` option.

### Options: Agent Programs

The CLI program can use an external program or an executable script to
request the password from a password manager.  The CLI provides 
a `cache-id` parameter that allows this program to determine which password is
required. Other parameters are used for display
purposes and correspond to the data required by the GNU Privacy Guard
password dialog.

~~~
0:   --clear             = clears any cached password to force reprompt
                           [only if zero-agent-cache option is set]
1:   --confirm=1         = for additional confirmation
2:   cache-id            = "bitmark-cli:password:<IDENTITY>"
3:   error-message       = ""
4:   prompt              = "<IDENTITY>"
5:   description         = shows create/transfer operation as a descriptive string
~~~

A sample `ask-gpg-agent` script is provided in the `bitmarkd` source
code repository; it can be used as a model to create a similar script for
other password managers.

## CLI Command Synopsis

-------------  ---------------------------------
setup          Initialize bitmark-cli configuration file
add            Add a new identity to configuration file
create         Create one or more new bitmarks
transfer       Transfer a bitmark to another account
countersign    Countersign a two-signature transaction
blocktransfer  Transfer a block to another account
provenance     List provenance of a bitmark
owned          List bitmarks owned
share          Convert a bitmark into a share
grant          Grant some shares of a bitmark to a receiver
swap           Swap some shares of a bitmark with a receiver
balance        Display balance of some shares
status         Display the status of a bitmark
list           List bitmark-cli identities
bitmarkd       Display bitmarkd information
seed           Decrypt and display identity's recovery seed
password       Change identity's password
fingerprint    Fingerprint a file (version 01 SHA3-512 algorithm)
sign           Sign file
verify         Verify file signature file
version        Display bitmark-cli version
help           Show a list of commands or help for one command
-------------  ---------------------------------


## CLI commands

### setup

Creates the initial configuration file for a network and sets the
default identity.  There are separate files for each network.

**Arguments.** Both the `--network` and `--identity` global options must
be set.

**Additional input.** Before creating the file, the CLI will prompt
for a password to encrypt the generated seed. Be sure to choose a good
random password to secure the account's private key.

**Errors.**  If the configuration file already exists, this command
will terminate with an error and not modify the file.

**Bugs.** Currently only adds one connection, with no way to update this
other than manual editing of the configuration file.

#### Command options

------------------------------  ---------------------------------
`--connect|-c HOST:PORT`        The default bitmarkd connection. This
                                TCP connection will be used for all data
                                submitted to the blockchain.

`--description|-d "STRING"`     A description string for the initial
                                identity.  This is only for the CLI
                                user; it is not used by any command and is not
                                sent over the network.

`--new|-n`                      An option that specifies that a new account seed is to be generated.

`--seed|-s SEED-STRING`         Used in place of `--new`. An
                                existing account seed to be placed into the CLI
                                configuration file.  The CLI accepts
                                both V1 and V2 Base58-encoded seeds.
------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing setup --connect=node-d1.test.bitmark.com:2130 --description="Bedrock Bowling Champion" --new
~~~

### add

Updates the configuration file by adding a new identity on a
network.

**Arguments.** Both the `--identity` and `--network` global options must
be specified.

**Additional input.** Before creating the file, the CLI will prompt for a
password to encrypt the generated seed. Choose a good random password
to secure the account's private key. The password is not prompted
when using the `--account` option since only the public key is
present.

**Errors.** The identity must not already exist or the command will
terminate with an error and not modify the file.

#### Command options

------------------------------  ---------------------------------
`--description|-d "STRING"`     A description string for the initial identity.
                                This is only descriptive text for the CLI user; it
                                is not used by any command nor sent over the network.

`--new|-n`                      An option that specifies that a new account seed is to be generated.

`--seed|-s SEED-STRING`         Used in place of `--new`. An
                                existing account seed to be placed into the CLI
                                configuration file.  The CLI accepts
                                both V1 and V2 Base58-encoded seeds.

`--account|-a ACCOUNT-STRING`   Used in place of `--new` or `--seed`. An existing
                                account to be imported into the CLI configuration file.  Since only the
                                public key is contained within the Base58-encoded account, this
                                identity cannot be used for signing items.  It is meant for use as
                                the recipient of a transfer.
------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=wilma --network=testing add --description="The real Ruler" --new
~~~


### create

Creates a bitmark by sending both an asset record and one
or more issue records.

**Arguments.** The `--network` global option must be specified.

**Additional input.** Before creating the Bitmark, the CLI will prompt
for a password to decrypt the identity's private key to perform the
signing operation.

**Errors.** The command will terminate with an error if the asset name
or metadata do not match exactly when creating additional Bitmarks.
In the "free issue (`--zero`)", case there will be an error if this issue
already exists.

#### Command options

------------------------------  ---------------------------------
`--asset|-a "STRING"`          A short name for the asset being issued.

`--metadata|-m "METADATA"`      A key-value map of data providing details
                                about the asset.  Keys and values
                                are separated by a zero byte, which is
                                represented using JSON encoding as
                                `"\u0000"`.

`--fingerprint|-f "STRING"`     A
                                globally unique identifier for an
                                asset, represented as any type of string. There is a `fingerprint` command
                                that will give the same hex string that
                                Bitmark Inc. applications also use.

`--zero|-z`                     An option that restricts the issue to the initial free one.
                                (See "Free issues" below)

`--quantity|-q NUMBER`          The number of Bitmarks to issue for a single payment, up to 100.  If
                                the free issue has not been created,
                                then only a quantity of one is allowed,
                                and this issue must be confirmed
                                before a larger quantity is allowed.
------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing create --asset='Fred Flintstone' --metadata='desc\u0000photo of Fred Flintstone\u0000src\u0000Wikipedia' --fingerprint=01ee0039791329016fc93e083ede6bd4266ed6f65812b483c05b5bf75252112178a4ffeeb4ede5949c6e4d9e26fba00f95fbc71b4fa7c5a9220bec49e6c18848fe
~~~


#### Note: Free issues

For any asset, there is a special issue that is free of cost.  Even if
the asset already exists, a different Bitmark account can create a free
issue for it.  Internally the issue record has a NONCE value of zero.

This leads to the following cases:

* For a new asset, a free issue must be made and must be confirmed before
  any other issue can be made against this asset.  Trying to issue
  quantity greater than one in this case will always fail as the
  confirmed asset does not yet exist.

* For a confirmed existing asset, an account that never made an issue
  against this asset could choose to make its single free issue or
  simply issue a quantity of two or more and pay for them.  In this
  case, the free issue does not have to be used, but the CLI will
  always attempt to make a free issue for a one-off issue and try a
  paid issue if it cannot.

### transfer

Transfers a bitmark to another account.

The default case is to perform a two-signature transfer, which requires
the use of the `countersign` command to produce the final record to
send to the blockchain.

If the unratified mode is used instead, then the transfer is sent immediately
and the payment details are returned.

**Arguments.** The `--network` global option must be specified.

**Additional input.** Before transferring a Bitmark, the CLI will
prompt for a password to decrypt the identity's private key to perform
the signing operation.

**Errors.** The command will terminate with an error if the transfer
cannot be validated by the blockchain.

#### Command options

-------------------------------  ---------------------------------
`--txid|-t HEX-ID`               The transaction id from a previous issue or transfer.

`--receiver|-r IDENTITY|ACCOUNT` The identity name for the account or else the
                                 account itself (in Base58) as the
                                 destination of the transfer.  If an
                                 identity is used it can be either a
                                 full account or a public-key-only
                                 item.  It is not necessary to know
                                 the password for this, and only the
                                 sender (specified by global identity
                                 option) needs to sign.

`--unratified|-u`                An option that specifies the single-signature transfer mode.  In
                                 this case, the transfer is sent
                                 directly to the block chain and
                                 payment information is shown.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing transfer --txid=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --receiver=barney
~~~


### countersign

Completes a two-signature operation.  This command takes the hex code from the operation
and signs with the global identity.

**Arguments.** The `--network` global option must be specified.

**Additional input.** Before creating the Bitmark, the CLI will prompt
for a password to decrypt the identity's private key to perform the
signing operation.

**Errors.** The command will terminate with an error if this identity
does not match the receiver in the transaction.

#### Command options

-------------------------------  ---------------------------------
`--transaction|-t HEX-DATA`      The transaction hex data from a previous
                                 transfer or other two-signature
                                 operation.  This data will only have a
                                 single signature.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=barney --network=testing countersign --transaction=05208981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee0021138a0b5c7ed5ab0c80bfd3968749e824f599bbf05540c045d26f72cedbfdb49977403e421917b8c1fbaa385b023fb84f19660e1b6f85e0f09473d6f7143de2450fba99dd931d2d42c01133e9e749dcb1d8a729114c0fe007a1617304f255274a7108
~~~


### blocktransfer

Transfers the ownership of a block to another account and/or changes
the cryptocurrency addresses.

This can only be used if the account belonging to a miner is added to
the CLI configuration.

**Arguments.** The `--network` global option must be specified.

**Additional input.** Before creating the Bitmark, the CLI will prompt
for a password to decrypt the identity's private key to perform the
signing operation.

**Errors.** The command will terminate with an error if the blockchain
cannot validate the transaction.

#### Command options
-------------------------------  ---------------------------------
`--txid|-t HEX-ID`               The transaction id from a previous issue or
                                 transfer.

`--receiver|-r IDENTITY|ACCOUNT` The identity name for the account or else the
                                 actual account (in Base58) as the
                                 destination of the transfer.  If an
                                 identity is used, it can be either a
                                 full account or a public-key-only
                                 item.  It is not necessary to know
                                 the password for this and only the
                                 sender (specified by global identity
                                 option) needs to sign.

`--bitcoin|-b ADDRESS`           A valid Bitcoin address for the corresponding
                                 network. All future earnings from
                                 the block will be sent to the new
                                 address.

`--litecoin|-l ADDRESS`          A valid Litecoin address for the corresponding
                                 network. All future earnings from
                                 the block will be sent to the new
                                 address.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing blocktransfer --txid=
~~~

### provenance

Displays the provenance of an asset starting from a particular transaction id and moving back
in time toward the issue record.  Since the record count is limited,
it may be necessary to use the last transaction id with a new call to
`provenance` to display more records, then repeat until the entire asset
record is output.

**Arguments.** The `--network` global option must be specified.

#### Command options

------------------------------  ---------------------------------
`--txid|-t HEX-ID`              The transaction id from a previous issue or
                                transfer.

`--count|-c NUMBER`             Limit for the number of provenance records displayed.
                                This defaults to 20 records if omitted
                                and can be set from 1 to 100.
------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing provenance --txid=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --count=10
~~~

### owned

Displays the ownership records for a given identity or account

**Arguments.** The `--network` global option must be specified.

#### Command options

------------------------------  ---------------------------------
`--owner|-o IDENTITY|ACCOUNT`   A different account to list records for, specified either by
                                an identity or a Base58
                                account string.  The default is to use
                                the global identity.

`--start|-s NUMBER`             An alternate start point rather the the default
                                of zero.  The output JSON includes a
                                field `next`, which if non-zero means
                                there are more records to display.
                                Just use the value of `next` in
                                subsequent `owned` commands to page
                                though all ownership records.

`--count|-c NUMBER`             Limit for the number of ownership records displayed.
                                This defaults to 20 records if omitted
                                and can be set from 1 to 100.
------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing owned
bitmark-cli --identity=fred --network=testing owned --owner barney
bitmark-cli --identity=fred --network=testing owned --owner eywWbSGcYaYPkY4e2aerGWRs1fNoaSDxh3BgLVENgBZmhTsdLz
~~~


### share

Converts a Bitmark into a fractions.  Once this is done, the provenance
is ended and only `grant` or `swap` commands can operate on the
fractions created.  The quantity of shares created must be some
meaningful value and once set can never be changed.

**Arguments.** The `--network` global option must be specified.

**Additional input.** Before creating the Bitmark Share, the CLI will
prompt for a password to decrypt the identity's private key to perform
the signing operation.

**Errors.** The command will terminate with an error if the
transaction id is already converted to shares.

#### Command options

-------------------------------  ---------------------------------
`--txid|-t HEX-ID`               The transaction id from a previous
                                 issue or transfer.

`--quantity|-d NUMBER`           A quantity of
                                 fractions to split the Bitmark into, up to the limit of an
                                 unsigned 64-bit number.  This sets the
                                 total number of shares available and is a
                                 permanent limit.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing share --txid=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --quantity=1000000
~~~

### grant

Transfers a number of shares of a particular share-id to a receiver.

**Arguments.** The `--network` global option must be specified.

**Additional input.** Before granting the Bitmark Share, the CLI will
prompt for a password to decrypt the identity's private key to perform
the signing operation.

**Errors.** The command will terminate with an error if the share
quantity is greater than the remaining balance.

#### Command options

-------------------------------  ---------------------------------
`--receiver|-r IDENTITY|ACCOUNT` The identity or Base58 account that
                                 is to receive the shares.

`--share-id|-s SHARE-ID`         The transaction id of the share record,
                                 which is used to identify the fractional item.

`--quantity|-q NUMBER`           The quantity of share to grant to the receiving
                                 account.  The default is one, but it can
                                 be any value up to the current
                                 balance of the owner.

`--before-block|-b NUMBER`       A time limit for
                                 the operation: the transaction
                                 must be submitted and confirmed
                                 before this block is present on the
                                 blockchain.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing grant --receiver=barney --share-id=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --quantity=1000 --before-block=234765
~~~


### swap

Performs an atomic swap between two different shares.

The system ensures the swap occurs as a single operation and that there is no
possibility of partial completion.  This is a two-signature command
and the recipient must use `countersign` to submit and pay before the
expiry block is reached on the blockchain.

**Arguments.** The `--network` global option must be specified.

**Additional input.** Before granting the Bitmark Share, the CLI will
prompt for a password to decrypt the identity's private key to perform
the signing operation.

**Errors.** The command will terminate with an error if the
share quantities are greater than the remaining balances.

#### Command options

-------------------------------  ---------------------------------
`--receiver|-r IDENTITY|ACCOUNT` The *countersigner* identity or Base58
                                 account.

`--share-id-one|-s SHARE-ID`     The transaction id of the share record,
                                 that the *initiator* is sending, used
                                 to identify the first fractional item.

`--quantity-one|-q NUMBER`       The quantity of `share-id-one` that the
                                 *initiator* is granting to the *countersigner*.
                                 The default is one, but it can be any value up to the
                                 current balance of the *initiator*.

`--share-id-two|-S SHARE-ID`     The transaction id of the share record,
                                 that the *countersigner* is sending, used
                                 to identify the second fractional item.

`--quantity-two|-Q NUMBER`       The quantity of  `share-id-two` that the
                                 *countersigner* is granting to the
                                 *initiator*.  The default is
                                 one, but it can be any value up to the
                                 current balance of the *countersigner*.

`--before-block|-b NUMBER`       A time limit for
                                 the operation: the transaction
                                 must be submitted and confirmed
                                 before this block is present on the
                                 blockchain.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing swap --receiver=barney --share-id-one=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --quantity-one=1000 --share-id-two=1bf75e25d7770ba6405500d39cac30f40249927fd3ee46beae42c9d9b85202f8 --quantity-otwo=79 --before-block=234765 --before-block=234765
~~~


### balance

Displays the share balances for a particular owner.

The display starts at a particular id and outputs `count` items.  To
display more, take the last share id displayed and use that in another `balance`
command. (To avoid a repeat of that record, use the incremented id as
the command to search for the next used id.)

**Arguments.** The `--network` global option must be specified.

#### Command options

-------------------------------  ---------------------------------
`--owner|-o IDENTITY|ACCOUNT`    An account, specified
                                 either by an identity or a Base58
                                 account string.  The default is to
                                 list balances for the global identity.

`--share-id|-s SHARE-ID`         The transaction id of the share record, which
                                 is used to identify the fractional
                                 item to show the balance.

`--count|-c NUMBER`              A limit on the number of balance records displayed.
                                 This defaults to 20 records if
                                 omitted and can be set from 1 to 100.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --identity=fred --network=testing balance --owner=barney --share-id=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --count=10
~~~


### status

Displays the status of a particular transaction id, to see whether it is:

* `Not found`: transaction not present on the blockchain or in that node's memory.
* `Pending`: transaction awaiting payment confirmation.
* `Verified`: payment is confirmed, and the transaction is waiting to be incorporated into a block.
* `Confirmed`: transaction stored on the blockchain.

**Arguments.** The `--network` global option must be specified.

#### Command options

-------------------------------  ---------------------------------
`--txid|-t HEX-ID`               The transaction id from a previous
                                 issue or transfer.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --network=testing status --txid=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee
~~~


### list

Displays all the configuration file identities' public data:

The returned information includes:

* `SK` flag to indicate the encrypted seed is present
* The short identity name
* Base58 account string (the encoded public key)
* Descriptive text

**Arguments.** The `--network` global option must be specified.

#### Example

~~~
bitmark-cli --network=testing list
~~~


### bitmarkd

Displays basic blockchain status from the selected bitmark node program.

**Arguments.** The `--network` global option must be specified.

#### Example

~~~
bitmark-cli --network=testing bitmarkd
bitmark-cli --network=testing --connection=2 bitmarkd
~~~


### seed

Displays the decrypted seed.  The output is a JSON block containing all
account data both public and private.

**Arguments.** The `--network` global option must be specified.

**Additional input.** Before displaying the seed, the CLI will
prompt for a password to decrypt the identity's private key
to be able to display it.

#### Command options

-------------------------------  ---------------------------------
`--recovery|-r`                  Only display the words of the recovery
                                 phrase in plain text.
-------------------------------  ---------------------------------

#### Examples

~~~
bitmark-cli --identity=fred --network=testing seed
bitmark-cli --identity=fred --network=testing seed --recovery
~~~


### password

Changes the password of the selected identity.

**Arguments.** The `--network` global option must be specified.

**Additional input.** The CLI will prompt for a password, then prompt
for the new password.  The new password will be prompted a second time
to ensure that the password was entered accurately.

#### Example

~~~
bitmark-cli --identity=fred --network=testing password
~~~


### fingerprint

Displays a fingerprint that is compatible with the method used by
other Bitmark Inc applications.  The result is shown as a hexadecimal
string.

**Arguments.** The `--network` global option must be specified.

#### Command options

-------------------------------  ---------------------------------
`--file|-f PATH-NAME`            The file for the fingerprint.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --network=testing fingerprint --file=Fred_Flintsone.png
~~~


### sign

Displays a signature for a file.  The result is shown as a hexadecimal
string.

**Arguments.** The `--network` global option must be specified.

**Additional input.** The CLI will prompt for a password to decrypt
the private key to perform the signing operation.

#### Command options

-------------------------------  ---------------------------------
`--file|-f PATH-NAME`            The file to sign
-------------------------------  ---------------------------------


#### Example

~~~
bitmark-cli --identity=fred --network=testing sign --file=Fred_Flintsone.png
~~~


### verify

Verifies the signature of a file matches the expected owner.  This is
the corresponding command to the `sign` command.

**Arguments.** The `--network` global option must be specified.

**Errors.** The command will indicate an error if the signature does
not match.

#### Command options

-------------------------------  ---------------------------------
`--file|-f PATH-NAME`            The file to verify

`--signature|-s HEX`             The signature hex string from the sign command

`--owner|-o IDENTITY|ACCOUNT`    The signer to check, specified by an identity
                                 or a Base58 account string.  The
                                 default is to use the global identity.
-------------------------------  ---------------------------------

#### Example

~~~
bitmark-cli --network=testing verify --file=Fred_Flintsone.png --owner=fred
~~~


### version

Displays the version of the CLI program.

#### Example

~~~
bitmark-cli --network=testing version
~~~
