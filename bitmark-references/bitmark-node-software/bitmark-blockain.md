# Basic Bitmark Blockchain Overview

This briefly describe the structure of the block chain. It builds up
from the transactions through to the final structure of the chain
itself.

## Definitions

The following items are used in the descriptions below.

Byte
: A single binary byte.

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
  representation the NUL byte will sho as `\u0000`.  The count is
  validated by various routines to prevent massive storage use.

Account
: The encoded Ed25519 public key, there is a type code in this to
  allow for other key types and it is preceeded by a VarInt byte
  count.  Currently the count will be 33.

Signature
: An Ed25519 signature over all previous bytes including VarInt
  fields.  This will preceeded by a VarInt that will be 64.  This
  value will change once other sinature algorithms are used and will
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

### Merkle tree

### Hashing (argon2, difficulty, proof of work ...)
