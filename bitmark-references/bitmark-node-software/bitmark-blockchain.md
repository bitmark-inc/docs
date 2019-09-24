# Basic Bitmark Blockchain Overview

This briefly describe the structure of the block chain. It builds up
from the transactions through to the final structure of the chain
itself.

## Definitions

The following items are used in the descriptions below.

Byte
: A single binary byte.

Unn
: An unsigned integer of "nn" bits length. Normally these will
  multiples of 8 bits like: U8, U16, U32, U64.

VarInt
: A sequence of 1 to 9 bytes that represents a 64 bit unsigned
  integer.  The high bit of each byte is used as a continuation flag
  so 0…127 can be represented by a single byte.  Each successive bytes
  adds 7 more bits and the values is in Little-Endian form. The 9^th^
  byte adds all eight bits bringing the total to 64.

String
: A sequence of UTF-8 byte sequence preceded by a VarInt byte count.
  The count is validated by various routines to prevent massive
  storage use.

Binary
: A sequence of bytes preceded by a VarInt byte count.  The count is
  validated by various routines to prevent massive storage use.

Map
: Sequence of NUL separated UTF-8 byte sequences preceded by a VarInt
  byte count.  There must be an even number sequences and these form
  key→value pairs.  The must not be a trailing NUL byte.  In JSON
  representation the NUL byte will show as `\u0000`.  The count is
  validated by various routines to prevent massive storage use.

Account
: The encoded Ed25519 public key, there is a type code in this to
  allow for other key types and it is preceeded by a VarInt byte
  count.  Currently the count will be 33.

Signature
: An Ed25519 signature over all previous bytes including VarInt
  fields.  This will preceeded by a VarInt that will be 64.  This
  value will change once other signature algorithms are used and will
  depend on the type code inside the Account field.


## Transactions: Asset, Issue and Transfer Records

The main sorts of transactions on the Bitmark blockchain are asset,
issue, and transfer records.  These are concerned with creating chains
of provenance for individual copies of specific assets.

### Asset Record

This contains the metadata to describe an asset that will be issued on
the blockchain.  All assets will have at least one issue.

The Record structure

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Asset Record type code
Name              String     Short descriptive name
Fingerprint       String     A unique identifier for the Asset
Metadata          Map        Key-Value to describe Asset
Registrant        Account    The public key of the signer
Signature         Signature  Ed25519 signature of signer

### Issue Record

This is the transaction that actually issues an asset or an additional
copy to an owner on the Bitmark blockchain.

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Issue Record type code
AssetId           Binary     Link to asset record (SHA3-512 of asset fingerprint)
Owner             Account    The public key of the signer
Nonce             VarInt     Allow for multiple issues of the same asset
Signature         Signature  Ed25519 signature of signer

### Transfer Record

The is the transaction to transfer ownership in a provenance chain on
the Bitmark blockchain.

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Transfer Record type code
Link              Binary     Link to previous Issue or Transfer (SHA3-256 of previous transaction)
Escrow            Payment    Optional escrow payment and address
Owner             Account    The public key of the new owner
Signature         Signature  Ed25519 signature of linked previous owner
CounterSignature  Signature  Ed25519 signature of this record owner


## Transactions: Share

### Bitmark Share

This record marks the end of a provenance chain and it splits the item
into an initial quantity of shares.  From this point the shares can
then be granted or swapped with other Bitmark owner accounts.

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Bitmark Balance type code
Link              Binary     Link to previous Issue or Transfer (SHA3-256 of previous transaction)
Quantity          VarInt     Initial balance quantity
Signature         Signature  Ed25519 signature of linked previous owner


### Share Grant

This transaction moves a quantity of shares from one owner to another.

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Share Grant type code
ShareId           Binary     Link to previous Issue (SHA3-256 of issue transaction)
Quantity          VarInt     Number of shares to transfer to recipient
Owner             Account    The public key of the current owner
Recipient         Account    The public key of the new owner
BeforeBlock       VarInt     Transaction expires after this block height
Signature         Signature  Ed25519 signature of current owner
CounterSignature  Signature  Ed25519 signature of recipient

### Share Swap

This transaction is used to perform an atomic swap between two owners
with two different share types.  The action is indivisible and there
is no possibility of a half transaction being executed.

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Share Swap type code
ShareIdOne        Binary     Link to previous Issue (SHA3-256 of issue transaction)
QuantityOne       VarInt     Number of shares one to transfer to owner two
OwnerOne          Account    The public key of the share one owner
ShareIdTwo        Binary     Link to previous Issue (SHA3-256 of issue transaction)
QuantityTwo       VarInt     Number of shares two to transfer to owner one
OwnerTwo          Account    The public key of the share two owner
BeforeBlock       VarInt     Transaction expires after this block height
Signature         Signature  Ed25519 signature of owner one
CounterSignature  Signature  Ed25519 signature of owner two

## Transactions: Block ownership record

### Block Foundation

This is the first transaction in a block and defines the ownership of
that block.  It is only set by the block mining process.  It is also
used to set the miners payment addresses which are used when
transaction reference those in this block.2

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Block Foundation type code
Version           VarInt     Sets the combination of supported currencies
Payments          Map        Map of Currency and Address
Owner             Account    The public key of the owner
Nonce             VarInt     Addional NONCE for mining
Signature         Signature  Ed25519 signature of owner


### Block Owner Transfer

This transaction allows the current owner of a block to transfer any
futre earnings from this block to another owner with new currency
addresses.

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Block Foundation type code
Link              Binary     Link to previous Foundation or Block Transfer (SHA3-256 of previous transaction)
Escrow            Payment    Optional escrow payment and address
Version           VarInt     Sets the combination of supported currencies
Payments          Map        Map of Currency and Address
Owner             Account    The public key of the new owner
Signature         Signature  Ed25519 signature of linked previous owner
CounterSignature  Signature  Ed25519 signature of this record owner


## Blockchain structure

Transactions are gathered together into blocks, which start with a
header followed by a foundation record and then the rest of the
transactions.

### Block Header

Item              Type       Description
----------------  ---------  ------------------------
Version           U16        The version control block rules in action
TransactionCount  U16        Number of transactions in the block
Number            U64        The number of this block
PreviousBlock     Argon2     Thirty two byte hash of the previous block
MerkleRoot        SHA3-256   Thirty two byte hash of the transaction Merkle tree
Timestamp         U64        Timestamp as a Unix (seconds after start of 1970-01-01)
Difficulty        U64        Difficulty fraction as 57 bit mantissa + 8 bit exponent
Nonce             U64        Nonce created by hashing to meet the difficulty

### Merkle tree

A Merkle Tree combines the hashes of individual records, such that
only the same records hashed together in the same order will result in
the same Merkle Tree root. It does so by hashing individual
transactions to create the leaves of a binary tree. Each pair of
hashes in the tree is then combined to form a new hash, repeating the
process until only a single hash is left: the Merkle Tree
root. Whenever a hash in the tree does not have a paired hash to
combine with, it is instead hashed with itself. The hashing process is
conducted by the SHA3-256 algorithm.

The SHA3 algorithm is the current recommended hashing algorithm to use
and fixes some vulnerability problems that were found in SHA2.  The
SHA2 would have to be uses twice to protect against this and that
costs more CPU resources.  The SHA3 is faster so reduces the time to
build the Merkle Tree.  SHA1 has been broken so was not considered.

The SHA3 algorithm is also used for transaction IDs and is simply the
hash of the packed binary transaction including all signatures.

### Block Hashing (argon2, difficulty, proof of work ...)

To prevent hardware attack of the Proof of Work system using GPUs or
ASICs a memory hard algorithm was used: Argon2.  Its parameters are
set such that a GPU will be some orders of magnitude slower that a
typical x86 CPU core.  At the settings uses the hashing power of CPUs
is still very low on the order of a few hashes per second, this means
that the difficulty scale is much lower than other blockchain systems.

The difficulty is represented as a
[https://en.wikipedia.org/wiki/Floating-point_arithmetic](floating
point) value in the range:

    1 ≥ d > 0

The hash is considered as a 256 bit fixed point value with 8 bits
before the decimal point:

    [8 bits] . [248 bits]

A hash meets the difficulty if it's value less than or equal to
difficulty value.

The difficulty value is encoded as a 57 bit mantissa, normalised so
that the most significant bit is one and can be dropped leaving 56 bits
to store:

~~~
    [8 bits exponent][56 bits mantissa] = 64 bit unsigned value

    mantissa is right shifted by exponent+8 from the most significant bit
    examples:
     the "One" value: 00 ff  ff ff  ff ff  ff ff
     represents the 256 bit value: 00ff ffff ffff ffff 8000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000

     value: 01 ff  ff ff  ff ff  ff ff
     represents the 256 bit value: 007f ffff ffff ffff c000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000

    Notes:
      1. the values here are shown as big endian, but the header is stored little endian
      2. the "one" value is current in the packed 64 bit for does represent exactly a difficulty of 1.0
~~~
