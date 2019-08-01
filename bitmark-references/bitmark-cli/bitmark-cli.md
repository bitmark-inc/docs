# bitmark-cli Command Reference

## Basic Command Structure

~~~
bitmark-cli [global-options] command [command-options]
~~~

## Global Options

Options are listed as long form with any single character abbreviation.

`--verbose|-v`

: This allows the CLI to output additional information for each
command.  Most commands will output the JSON request and response sent
to the bitmarkd.

`--network|-n  [bitmark|testing|local]`

: Determines which network the command will be sent to from the following possible values:
* `bitmark` the live network which uses live BTC or LTC to pay for the transactions.
* `testing` a network for testing newly developed programs, it uses testnet coins to pay for transactions.
* `local` a special case for running a regression test network on the loopback interface.

`--connection|-c NUMBER`

: Optionally allows for one of the other connections listed in the
configuration file to be used instead of defaulting to the first one.

`--identity|-i NAME`

: Optionally override the default identity to allow running commands
as another account.  Extra accounts are appended to the configuration
file using the `add` command.

`--password|-p PASSWORD`

: This is primarily used for regression testing scripts to supply a
password.  It is not recommended for normal use as the password will
be left in the command history or be viewable by a process display
command (top, ps, etc.)

`--use-agent|-u EXECUTABLE`

: This is the way to access a password stored in a password manager. the
executable must accept the following arguments:

~~~
1:   --confirm=1         = for additional confirm
2:   cache-id            = "bitmark-cli:password:<IDENTITY>"
3:   error-message       = ""
4:   prompt              = "<IDENTITY>"
5:   description         = descriptive string shows create/transfer operation
~~~

`--zero-agent-cache|-z`

: Prepends a `--clear` to the argument list of the `--use-agent` command
to force the password manager to re-prompt for the password.

## CLI Command Synopsis

setup
: initialise bitmark-cli configuration

add
: add a new identity to config file

create
: create one or more new bitmarks

transfer
: transfer a bitmark to another account

countersign
: countersign a transaction using current identity

blocktransfer
: transfer a bitmark to another account

provenance
: list provenance of a bitmark

owned
: list bitmarks owned

share
: convert a bitmark into a share

grant
: grant some shares of a bitmark to a receiver

swap
: swap some shares of a bitmark with a receiver

balance
: display balance of some shares

status
: display the status of a bitmark

list
: list bitmark-cli identities

bitmarkd
: display bitmarkd information

seed
: decrypt and display identity's recovery seed

password
: change identity's password

fingerprint
: fingerprint a file (version 01 SHA3-512 algorithm)

sign
: sign file

verify
: verify file signature file

version
: display bitmark-cli version

help
: Shows a list of commands or help for one command


## CLI commands

### setup

Used to initially create the configuration file for a network and sets
the default identity, so both these global flags must be specified.
If the configuration file already exists then this command will
terminate with an error and not modify the file.

Before creating the file the CLI will prompt for a password to encrypt
the generated seed, choose a good random password in order to secure
the account's private key.

#### OPTIONS

`--connect|-c HOST:PORT`
: Sets the default bitmarkd connection

`--description|-d "STRING"`
: Sets a description string for the initial identity.  This is only
  for the CLI user, it is not used by and command or sent over the
  network.

`--new|-n`
: Specifies that a new account seed is to be generated.

`--seed|-s SEED-STRING`
: This is used in place of `--new` to import an existing account seed
  into the CLI configuration file.  The CLI accepts both V1 and V2
  Base58 encoded seeds.


#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing setup --connect=node-d1.test.bitmark.com:2130 --description="Bedrock Bowling Champion" --new
~~~


### add

Update the configuration file, adding a new identity for a
network. Both `--identity` and `--newtork` global flags must be
specified.

Before creating the file the CLI will prompt for a password to encrypt
the generated seed, choose a good random password in order to secure
the account's private key.  The password is not prompted when using
the `--account` option since only the public key is present.

#### OPTIONS

`--description|-d "STRING"`
: Sets a description string for the initial identity.  This is only
  for the CLI user, it is not used by and command or sent over the
  network.

`--new|-n`
: Specifies that a new account seed is to be generated.

`--seed|-s SEED-STRING`
the account's private key.  The password is not prompted when using
the `--account` option since only the public key is present.

#### OPTIONS

`--description|-d "STRING"`ity.  This is only
  for the CLI user, it is not used by and command or sent over the
  network.

`--new|-n`
: Specifies that a new account seed is to be generated.

`--seed|-s SEED-STRING`
the account's private key.  The password is not prompted when using
the `--account` option since only the public key is present.

#### OPTIONS

`--description|-d "STRING"`
: Sets a description string for the initial identity.  This is only
  for the CLI user, it is not used by and command or sent over the
  network.

`--new|-n`
: Specifies that a new account seed is to be generated.

`--seed|-s SEED-STRING`
: This is used in place of `--new` to import an existing account seed
  into the CLI configuration file.  The CLI accepts both V1 and V2
  Base58 encoded seeds.

`--account|-a ACCOUNT-STRING`
: This is used in place of `--new` or `--seed` to import an existing
  account into the CLI configuration file.  Since this is only the
  public key is contained within the Base58 encoded account, this
  identity cannot be used for signing items.  It is meant for use as
  the recipient of a transfer.


#### OPTIONS table

------------------------------- ---------------------------------
`--description -d "STRING"`     Sets a description string for the initial identity.  This is only
                                for the CLI user, it is not used by and command or sent over the
                                network.

`--new -n`                      Specifies that a new account seed is to be generated.

`--seed -s SEED-STRING`         This is used in place of `--new` to import an existing account seed
                                into the CLI configuration file.  The CLI accepts both V1 and V2
                                Base58 encoded seeds.

`--account -a ACCOUNT-STRING`   This is used in place of `--new` or `--seed` to import an existing
                                account into the CLI configuration file.  Since only the
                                public key is contained within the Base58 encoded account, this
                                identity cannot be used for signing items.  It is meant for use as
                                the recipient of a transfer.
------------------------------- ---------------------------------


#### EXAMPLE

~~~
bitmark-cli --identity=wilma --network=testing add --description="The real Ruler" --new
~~~


### create

This command create a bitmark by sending both an Asset record and one
or more issue records.

The first issue is free, but the CLI must solve a proof-of-work
problem to do this.  Subsequent issues after the first is confirmed
require payment and this command will display the appropriate
`bitmark-wallet` command for the supported crypto-currencies.

#### OPTIONS

`--asset|-a "STRING"`
: A short name to describe the asset being issued

`--metadata|-m "METADATA"`
: A key-value map of data to provide details about the asset.  The
  keys and values are separated by a zero byte which is represented
  using JSON encoding as `"\u0000"`

`--fingerprint|-f "STRING"`
: Any kind of string that represents a globally unique identifier for
  an asset.  The `fingerprint` command below will give a hex string
  that Bitmark Inc. applications also use.

`--zero|-z`
: Restrict the issue to the initial free one.  This will return an
  error if the free issue has already been used for this asset. It is
  intended for use in a script where doing an additional paid issue is
  not wanted.

`--quantity|-q NUMBER`
: Allows issuing a block of bitmarks for a single payment up to a
  maximum of 100.  If the free issue had not been created then only a
  quantity of one is allowed and this issue must be confirmed before a
  larger quantity is allowed.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing create --asset='Fred Flintstone' --metadata='desc\u0000photo of Fred Flintstone\u0000src\u0000Wikipedia' --fingerprint=01ee0039791329016fc93e083ede6bd4266ed6f65812b483c05b5bf75252112178a4ffeeb4ede5949c6e4d9e26fba00f95fbc71b4fa7c5a9220bec49e6c18848fe
~~~

### transfer

To transfer a bitmark to another account.

The default case is to perform a two signature transfer and requires
the use of the `countersign` command to produce the final record to
send to the blockchain.  The recipient who countersigns must be the
same as the recipient in the transfer.

If the unratified mode is used then the transfer is sent right away
and the payment details are returned.

#### OPTIONS

`--txid|-t HEX-ID`
: The transaction id from a previous issue or transfer.

`--receiver|-r IDENTITY|ACCOUNT`
: Identity name for the account or the account (in Base58) as the
  destination of the transfer.  If an identity is used it can be
  either a full account or a public key only item.  It is not
  necessary to know the password for this and only the sender
  (specified by global identity option) needs to sign.

`--unratified|-u`
: For into the single signature transfer mode.  In this case the
  transfer is sent directly to the block chain and pyment information
  is shown.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing transfer --txid=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --receiver=barney
~~~

### countersign

To complete a two signature operation.  This command take the hex code
and signs with the global identity.  This identity must match the
receiver in the transaction or the blockchain will reject it.

#### OPTIONS

`--transaction|-t HEX-DATA`
: The transaction hex data from a previous transfer or other two
  signature operation.  This data will only have a single signature.


#### EXAMPLE

~~~
bitmark-cli --identity=barney --network=testing countersign --transaction=05208981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee0021138a0b5c7ed5ab0c80bfd3968749e824f599bbf05540c045d26f72cedbfdb49977403e421917b8c1fbaa385b023fb84f19660e1b6f85e0f09473d6f7143de2450fba99dd931d2d42c01133e9e749dcb1d8a729114c0fe007a1617304f255274a7108
~~~


### blocktransfer

To transfer the ownership of a block to another account and/or change
the crypto-currency addresses.

This can only be used if the account belonging to a miner is added to
the CLI configuration.

#### OPTIONS

`--txid|-t HEX-ID`
: The transaction id from a previous issue or transfer.

`--receiver|-r IDENTITY|ACCOUNT`
: Identity name for the account or the account (in Base58) as the
  destination of the transfer.  If an identity is used it can be
  either a full account or a public key only item.  It is not
  necessary to know the password for this and only the sender
  (specified by global identity option) needs to sign.

`--bitcoin|-b ADDRESS`
: A valid Bitcoin address for the corresponding network. All future
  earnings from that block will be sent to the new address.

`--litecoin|-l ADDRESS`
: A valid Litecoin address for the corresponding network. All future
  earnings from that block will be sent to the new address.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing blocktransfer --txid=
~~~


### provenance

Display the provenance starting from a particular transaction id back
in time towards the issue record.  Since the record count is limited
it may be necessary to use the last transaction id with a new call to
`provenance` to display more records; then repeat until the asset
record is output.

#### OPTIONS

`--txid|-t HEX-ID`
: The transaction id from a previous issue or transfer.

`--count|-c NUMBER`
: Limit the number of provenance records displayed.  This defaults to
  20 records if omitted and can be set from 1 to 100.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing provenance --txid=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --count=10
~~~


### owned

Display the ownership records for a given identity or account

#### OPTIONS

`--owner|-o IDENTITY|ACCOUNT`
: To list records for a different account either by an identity or a
  Base58 account string.  The default is to use the global identity.

`--start|-s NUMBER`
: Specify another start point rather the the default of zero.  The
  output JSON includes a field `next` which if non-zero means there
  are more records to display.  Just use the value of `next` in
  subsequent `owned` commands to page though all ownership records.

`--count|-c NUMBER`
: Limit the number of ownership records displayed.  This defaults to
  20 records if omitted and can be set from 1 to 100.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing owned
bitmark-cli --identity=fred --network=testing owned --owner barney
bitmark-cli --identity=fred --network=testing owned --owner eywWbSGcYaYPkY4e2aerGWRs1fNoaSDxh3BgLVENgBZmhTsdLz
~~~


### share

Convert a bitmark into a fractions.  Once this is done the provenance
is ended and only `grant` or `swap` commands can operate on the
fractions created.  The quantity of shares created should be some
meaningful value and once set can never be changes.

#### OPTIONS

`--txid|-t HEX-ID`
: The transaction id from a previous issue or transfer.

`--quantity|-d NUMBER`
: Split the bitmark up into a quantity of fractions up to the limit of
  an unsigned 64 bit number.  This sets to total number available and
  is a permanent limit.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing share --txid=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --quantity=1000000
~~~


### grant

Transfer a number of shares of a particular id to a receiver.

#### OPTIONS

`--receiver|-r IDENTITY|ACCOUNT`
: The identity or Base58 account that is to receive the shares.

`--share-id|-s SHARE-ID`
: The transaction id of the share record, which is used to identify
  the fractional item.

`--quantity|-q NUMBER`
: The quantity of share to grant to the receiving account.  The
  default is one and can be any value up to the current balance of the
  owner.

`--before-block|-b NUMBER`
: This is used to provide a "time" limit on the operation and the
  transaction must be submitted and confirmed before this block is
  present on the blockchain.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing grant --receiver=barney --share-id=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --quantity=1000 --before-block=234765
~~~


### swap

Perform an atomic swap between two different shares.  The owner send
quantity-one share-one to the recipient.  The recipient sends
quantity-two of share-two to the owner.  The system ensures the swap
occurs as a single operation and no possibility of partial completion.
This is a two signature command ad the recipient must use
`countersign` to submit and pay before the expiry block is reached on
the blockchain.

#### OPTIONS

`--receiver|-r IDENTITY|ACCOUNT`
: The identity or Base58 account that is to receive the shares.

`--share-id-one|-s SHARE-ID`
: The transaction id of the share record, which is used to identify
  the fractional item.

`--quantity-one|-q NUMBER`
: The quantity of share to grant to the receiving account.  The
  default is one and can be any value up to the current balance of the
  owner.

`--share-id-two|-S SHARE-ID`
: The transaction id of the share record, which is used to identify
  the fractional item.

`--quantity-two|-Q NUMBER`
: The quantity of share to grant to the receiving account.  The
  default is one and can be any value up to the current balance of the
  owner.

`--before-block|-b NUMBER`
: This is used to provide a "time" limit on the operation and the
  transaction must be submitted and confirmed before this block is
  present on the blockchain.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing grant --receiver=barney --share-id=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --quantity=1000 --before-block=234765
~~~


### balance

Display the share balances for a particular owner.  The display starts
at the particular id and outputs `count` items.  To display more take
the last share id and use in another `balance` command.  (To avoid a
repeat of that record use the incremented id as the command will
search for the next used id)

#### OPTIONS

`--owner|-o IDENTITY|ACCOUNT`
: To list records for a different account either by an identity or a
  Base58 account string.  The default is to use the global identity.

`--share-id|-s SHARE-ID`
: The transaction id of the share record, which is used to identify
  the fractional item to show the balance.

`--count|-c NUMBER`
: Limit the number of balance records displayed.  This defaults to
  20 records if omitted and can be set from 1 to 100.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing balance --owner=barney --share-id=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee --count=10
~~~


### status

Display the status of a particular transaction id to set whether it is:

* Not found = not present on the blockchain or in that node's memory.
* Pending = awaiting payment confirmation.
* Verified = payment is confirmed and just waiting to be incorporated into a block.
* Confirmed = store on the blockchain.

#### OPTIONS

`--txid|-t HEX-ID`
: The transaction id from a previous issue or transfer.

#### EXAMPLE

~~~
bitmark-cli --network=testing status --txid=8981eb58c965e2360b3ffeedf47d8f770a2fff7f67e5c348302d839afbf83dee
~~~


### list

Display all the configuration file identities' public data:

* `SK` flag to indicate the encrypted seed is present
* The short identity name
* Base58 account string (the encoded public key)
* Descriptive text

#### OPTIONS

#### EXAMPLE

~~~
bitmark-cli --network=testing list
~~~


### bitmarkd

Display basic blockchain status from the selected bitmark node program.

#### OPTIONS

#### EXAMPLE

~~~
bitmark-cli --network=testing bitmarkd
bitmark-cli --network=testing --connection=2 bitmarkd
~~~


### seed

Display the decrypted seed basic blockchain status from the selected
bitmark node program.  The output is a JSON block containing all
account data both public and private.

#### OPTIONS

`--recovery|-r`
: Only display the words of the recovery phrase in plain text.


#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing seed
bitmark-cli --identity=fred --network=testing seed --recovery
~~~


### password

Change the password of the selected identity.  The program will prompt
for old password then the new password twice to ensure accurate entry.


#### OPTIONS

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing password
~~~


# fingerprint

Display a hex fingerprint that is compatible to the method used by
other Bitmark Inc applications.  The result is shown as a hexadecimal
string.

#### OPTIONS

`--file|-f PATH-NAME`
: Specify the file to fingerprint.

#### EXAMPLE

~~~
bitmark-cli --network=testing fingerprint --file=Fred_Flintsone.png
~~~


# sign

Display a hex signature for a file.  The global identity is

#### OPTIONS

`--file|-f PATH-NAME`
: Specify the file to sign.

#### EXAMPLE

~~~
bitmark-cli --identity=fred --network=testing sign --file=Fred_Flintsone.png
~~~


# verify

Verify the signature of a file matches the expected owner.  This is
the corresponding command to the `sign` command.

#### OPTIONS

`--file|-f PATH-NAME`
: Specify the file to sign.

`--owner|-o IDENTITY|ACCOUNT`
: To check the signer by an identity or a Base58 account string.  The
  default is to use the global identity.

#### EXAMPLE

~~~
bitmark-cli --network=testing verify --file=Fred_Flintsone.png --owner=fred
~~~


# version

Display the version of the CLI program.

#### OPTIONS

#### EXAMPLE

~~~
bitmark-cli --network=testing version
~~~


<!-- LocalWords: Prepends BTC LTC testnet loopback -->
