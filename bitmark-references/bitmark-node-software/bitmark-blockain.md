# Basic Bitmark Blockchain Overview

This briefly describe the structure of the block chain. It builds up
from the transactions through to the final structure of the chain
itself.

## Definitions

The following items are used in the descriptions below.

Byte
: A single binary byte.

Unn
: An unsigned integer of "nn" bits length.

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

### Asset Record

This contains the metadata to describe an asset that will be issued on
the blockchain.  All assets will have at least one issue.

The Asset Record structure

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Asset Record type code
Name              String     Short descriptive name
Fingerprint       String     A unique identifier for the Asset
Metadata          Map        Key-Value to describe Asset
Registrant        Account    The public key of the signer
Signature         Signature  Ed25519 signature of signer


The Issue Record structure

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Issue Record type code
AssetId           Binary     Link to asset record
Owner             Account    The public key of the signer
Nonce             VarInt     Allow for multiple issues of the same asset
Signature         Signature  Ed25519 signature of signer

The Transfer Record structure

Item              Type       Description
----------------  ---------  ------------------------
Type code         Byte       Transfer Record type code
Link              Binary     Link to previous Issue or Transfer
Owner             Account    The public key of the signer
Signature         Signature  Ed25519 signature of linked previous owner
CounterSignature  Signature  Ed25519 signature of this record owner


## Transactions: Share


## Transactions: Block ownership record


## Blockchain structure

### Block Header

Item              Type       Description
----------------  ---------  ------------------------
Version           U16        The version control block rules in action
TransactionCount  U16        Number of transactions in the block
Number            U64        The number of this block
PreviousBlock     Argon2     Thirty two byte has of the previous block
MerkleRoot        SHA3-256   Thirty two byte has of the transaction Merkle tree
Timestamp         U64        Timestamp as a Unix (seconds after start of 1970-01-01)
Difficulty        U64        Difficulty fraction as 57 bit mantissa + 8 bit exponent
Nonce             U64        Nonce created by hashing to meet the difficulty

### Merkle tree

This is a way of combining hashes of a list of records to obtain a
single hash such that only the same records in the same order will
have the same hash.  It is done by making the hashes of all the
records the final elements in a binary tree, with each pair hashed
together to get the value above.  Any item not forming a pair at at
some level of the tree is hashed with itself.  The final hash is known
as the root.  In this system the SHA3-256 algorithm is used for the
hashing process.

The SHA3 algorithm is the current recommended hashing algorithm to use
and fixes some vulnerability problems that were found in SHA2.  The
SHA2 would have to be uses twice to protect against this and that
costs more CPU resources.  The SHA3 is faster so reduces the time to
build the Merkle Tree.  SHA1 has been broken so was not considered.


### Block Hashing (argon2, difficulty, proof of work ...)

To prevent hardware attack of the Proof of Work system using GPUs or
ASICs a memory hard algorithm was used: Argon2.  Its parameters are
set such that a GPU will be some orders of magnitude slower that a
typical x86 CPU core.  At the settings uses the hashing power of CPUs
is still very low on the order of a few hashes per second, this means
that the difficulty scale is much lower than other blockchain systems.

The difficulty is represented as a floating point value in the range:

    1 ≥ d > 0

The hash is considered as a 256 bit fixed point value with 8 bits
before the decimal point:

    [8 bits] . [248 bits]

A hash meets the difficulty if it's value less than or equal to
difficulty value.

The difficulty value is encoded as a 57 bit mantissa, normalised so
that the most significant bit is one and can be dropped leaving 56 bits
to store:

    [56 bits mantissa][8 bits exponent] = 64 bit unsigned value

    mantissa is right shifted by exponent+8 from the most significant bit
    examples:
     the "One" value: 00 ff  ff ff  ff ff  ff ff
     represents the 256 bit value: 00ff ffff ffff ffff 8000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000

     value: 01 ff  ff ff  ff ff  ff ff
     represents the 256 bit value: 007f ffff ffff ffff c000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000

    Note: the values here are shown as big endian, but the header is stored little endian
