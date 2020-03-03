---
title: Blockchain Overview
keywords: blockchain
last_updated: 
sidebar: mydoc_sidebar
permalink: /explore-the-protocol-docs/blockchain-overview
folder: explore-the-protocol-docs
---

# Blockchain Overview

This brief description of the structure of the structure of the Bitmark blockchain moves
from the transactions up to the final structure of the chain
itself.

## Definitions

The following variable types are used in most Bitmark records:

Account
: An encoded Ed25519 public key. Contains a type code to
  allow for other key types. It is preceded by a _VarInt_ _byte_
  count that is currently set to 33.
  
Binary
: A sequence of _bytes_ preceded by a _VarInt_ byte count.  The count is
  validated by various routines to prevent excessive storage use.

Byte
: A single _binary_ byte.

Map
: A sequence of NULL-separated UTF-8 _byte_ sequences preceded by a _VarInt_
  byte count. The count is
  validated by various routines to prevent excessive storage use.
  There must be an even number of sequences, as they form
  key-value pairs. There must not be a trailing NULL byte.  In JSON
  representation, the NULL byte will show as `\u0000`.  

Signature
: An Ed25519 signature over all previous _bytes_ including _VarInt_
  fields. It is preceded by a VarInt with a count of 64.  This
  value will change once other signature algorithms are used and will
  depend on the type code inside the _Account_ field.
  
String
: A sequence of UTF-8 _bytes_ preceded by a _VarInt_ byte count.
  The count is validated by various routines to prevent excessive storage use.

VarInt
: A sequence of 1 to 9 _bytes_ that represents a 64-bit unsigned
  integer in Little-Endian form. The high bit of each byte is used as a continuation flag,
  so 0 … 127 can be represented by each byte. Each successive byte
  adds 7 more bits. The 9th byte does not have a continuation flag, so it adds eight bits to the integer, bringing the total for the nine bytes to 64 bits.
  
The following variable types are used only in Bitmark block headers, because they are fixed length fields:

Unn
: An unsigned integer with a length of `"nn"` bits. Normally this will be
  multiples of 8 bits such as: U8, U16, U32, U64. 

## Transactions: Asset, Issue, and Transfer Records

The main types of transactions on the Bitmark blockchain are asset,
issue, and transfer records. Together, they create chains
of provenance for individual copies of specific assets.

Asset records have an identifier that is the SHA3-512 hash of the bytes
making up the fingerprint.  This allows the fingerprint field to contain
any data, binary, or text and to be represented by a fixed length 64-byte
identifier in issue records.  Only using the fingerprint for the hash
prevents duplicate assets that have the same fingerprint but different
names or metadata.

Other transactions have an identifier that is the SHA3-256 hash of
the entire record (including all signatures). This shorter identifier
of 256 bits is used both to save space in records and to easily distinguish
transaction IDs from asset IDs.

### Asset Record

An asset record contains the metadata describing an asset that will be issued on
the blockchain.  All assets will have at least one issue.

The Record structure:

Item             | Type      | Description
:--------------- | :-------- | :-----------------------
Type code        | Byte      | Asset Record type code
Name             | String    | Short descriptive name
Fingerprint      | String    | Unique identifier for the Asset
Metadata         | Map       | Key-Value to describe Asset
Registrant       | Account   | Public key of the signer
Signature        | Signature | Ed25519 signature of signer

### Issue Record

An issue record actually issues an asset (or an additional
copy of an asset) to an owner on the Bitmark blockchain.

Each issue must have a unique nonce value to distinguish individual
copies of that asset.

Item             | Type        | Description
:--------------- | :---------- | :-----------------------
Type code        | Byte        | Issue Record type code
AssetId          | Binary      | Link to asset record (SHA3-512 of asset fingerprint)
Owner            | Account     | The public key of the signer
Nonce            | VarInt      | Allow for multiple issues of the same asset
Signature        | Signature   | Ed25519 signature of signer

### Transfer Record

A transfer record transfers ownership of an issued asset in a provenance chain on
the Bitmark blockchain.

Item             | Type        | Description
:--------------- | :---------- | :-----------------------
Type code        | Byte        | Transfer Record type code
Link             | Binary      | Link to previous Issue or Transfer (SHA3-256 of previous transaction)
Escrow           | Payment     | Optional escrow payment and address
Owner            | Account     | The public key of the new owner
Signature        | Signature   | Ed25519 signature of linked previous owner
CounterSignature | Signature   | Ed25519 signature of this record owner


## Transactions: Share

The Bitmark blockchain also supports transactions that deal with fractional bitmarks as a
kind of fungible token.

### Share Balance Record

A share balance record marks the end of a provenance chain. It splits the issued asset
into an initial quantity of shares.  From this point on, the shares can
 be granted or swapped with other Bitmark accounts.

Item             | Type        | Description
:--------------- | :---------- | :-----------------------
Type code        | Byte        | Bitmark Balance type code
Link             | Binary      | Link to previous Issue or Transfer (SHA3-256 of previous transaction)
Quantity         | VarInt      | Initial balance quantity
Signature        | Signature   | Ed25519 signature of linked previous owner


### Share Grant Record

A share grant record moves a quantity of shares from one owner to another.

Item             | Type        | Description
:--------------- | :---------- | :-----------------------
Type code        | Byte        | Share Grant type code
ShareId          | Binary      | Link to previous Issue (SHA3-256 of issue transaction)
Quantity         | VarInt      | Number of shares to transfer to recipient
Owner            | Account     | Public key of the current owner
Recipient        | Account     | Public key of the new owner
BeforeBlock      | VarInt      | Expiry block height for transaction
Signature        | Signature   | Ed25519 signature of current owner
CounterSignature | Signature   | Ed25519 signature of recipient

### Share Swap Record

A share swap record performs an atomic swap between two owners
with two different share types.  The action is indivisible, and there
is no possibility of a half transaction being executed.

Item             | Type        | Description
:--------------- | :---------- | :-----------------------
Type code        | Byte        | Share Swap type code
ShareIdOne       | Binary      | Link to previous Issue (SHA3-256 of issue transaction)
QuantityOne      | VarInt      | Number of shares one to transfer to owner two
OwnerOne         | Account     | The public key of the share one owner
ShareIdTwo       | Binary      | Link to previous Issue (SHA3-256 of issue transaction)
QuantityTwo      | VarInt      | Number of shares two to transfer to owner one
OwnerTwo         | Account     | The public key of the share two owner
BeforeBlock      | VarInt      | Expiry block height for transaction
Signature        | Signature   | Ed25519 signature of owner one
CounterSignature | Signature   | Ed25519 signature of owner two

## Transactions: Block Ownership

Finally, the Bitmark blockchain also supports a few transactions for defining block ownership.

### Block Foundation Record

A block foundation record is the first transaction in a block and defines the ownership of
that block.  It is only set by the block mining process.  It is also
used to set the miner's payment addresses, which are used when
transactions reference those in the block.

Item             | Type        | Description
:--------------- | :---------- | :-----------------------
Type code        | Byte        | Block Foundation type code
Version          | VarInt      | Sets the combination of supported currencies
Payments         | Map         | Map of Currency and Address
Owner            | Account     | Public key of the owner
Nonce            | VarInt      | Additional NONCE for mining
Signature        | Signature   | Ed25519 signature of owner


### Block Owner Transfer Record

A block owner transfer record allows the current owner of a block to transfer any
future earnings from that block to another owner, with new currency
addresses.

Item             | Type        | Description
:--------------- | :---------- | :-----------------------
Type code        | Byte        | Block Foundation type code
Link             | Binary      | Link to previous Foundation or Block Transfer (SHA3-256 of previous transaction)
Escrow           | Payment     | Optional escrow payment and address
Version          | VarInt      | Sets the combination of supported currencies
Payments         | Map         | Map of Currency and Address
Owner            | Account     | Public key of the new owner
Signature        | Signature   | Ed25519 signature of linked previous owner
CounterSignature | Signature   | Ed25519 signature of this record owner

## Blockchain structure

Transactions are gathered together into blocks, which start with a
block header, followed by a single foundation record and then the rest of the
transactions.

A block is secured by having a nonce and a difficulty
value embedded in the header. The difficulty can only change at
specific points and in specific ways defined in the `bitmarkd` consensus
algorithm; any block with a difficulty that does not comply is
immediately rejected. It is possible to determine if a header
is valid by checking if its hash value is less than or equal to the
value indicated by the difficulty.  

The chain itself is formed by storing the hash of the previous block in the
block header, which links the current block to the previous block.

### Block Header

The block header is used both to provide metadata (like timestamp) for
a block and to verify that the list of transactions attached
to the block are valid.

Item             | Type        | Description
:--------------- | :---------- | :-----------------------
Version          | U16         | Version of block rules in action
TransactionCount | U16         | Number of transactions in the block
Number           | U64         | The number of this block
PreviousBlock    | Argon2      | Thirty-two byte hash of the previous block
MerkleRoot       | SHA3-256    | Thirty-two byte hash of the transaction Merkle tree
Timestamp        | U64         | UNIX timestamp (seconds after start of 1970-01-01)
Difficulty       | U64         | Difficulty fraction as 57 bit mantissa + 8 bit exponent
Nonce            | U64         | Nonce created by hashing to meet the difficulty

### Merkle Tree

A Merkle Tree combines the hashes of individual records, such that
only the same records hashed together in the same order will result in
the same Merkle Tree root. It does so by hashing individual
transactions using the SHA3-256 algorithm to create the leaves of a binary tree. Each pair of
hashes in the tree is then combined to form a new hash. Whenever a hash in the tree does not have a paired hash to
combine with, it is instead hashed with itself.  This process is repeated until only a single hash is left: the Merkle Tree
root. 

The SHA3 algorithm is the current recommended hashing algorithm to use
and fixes some vulnerability problems that were found in SHA2.  The
SHA2 algorithm would have to be used twice to protect against this, which would
cost more CPU resources.  The SHA3 is faster, so it reduces the time to
build the Merkle Tree. SHA-1 has been broken, so it was not considered.

The SHA3 algorithm is also used for transaction IDs and is similarly the
hash of the packed binary transaction including all signatures.

### Block Hashing (Argon2, difficulty, proof of work ...)

To prevent hardware attack of the Proof of Work system using GPUs or
ASICs, a memory hard algorithm is used: Argon2.  Its parameters are
set such that a GPU will be some orders of magnitude slower that a
typical x86 CPU core.  The current setting for the hashing power of CPUs
is still very low, on the order of a few hashes per second; this means
that the difficulty scale is much lower than other blockchain systems.

The difficulty is represented as a
[https://en.wikipedia.org/wiki/Floating-point_arithmetic](floating
point) value in the range:

    1 ≥ d > 0

The difficulty value is encoded as a 57-bit mantissa, normalized so
that the most significant bit is one and can be dropped, leaving 56 bits
to store:

~~~
    [8 bits exponent][56 bits mantissa] = 64 bit unsigned value

    mantissa is right shifted by exponent+8 from the most significant bit
    
    Examples:
     the "One" value: 00 ff  ff ff  ff ff  ff ff
     represents the 256 bit value: 00ff ffff ffff ffff 8000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000

     value: 01 ff  ff ff  ff ff  ff ff
     represents the 256 bit value: 007f ffff ffff ffff c000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000

    Notes:
      1. the values here are shown as big endian, but the header is stored little endian
      2. the "one" value represents exactly a difficulty of 1.0 in the packed 64 bits
~~~

The hash is considered as a 256-bit fixed point value with 8 bits
before the decimal point:

    [8 bits] . [248 bits]

A hash meets the difficulty if its value is less than or equal to
difficulty value.

