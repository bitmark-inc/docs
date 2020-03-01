---
title: RPC Communication
keywords: rpc
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-node-software/rpc-communication
folder: bitmark-references/bitmark-node-software
---

# RPC Communication

## Overview

RPC (remote procedure call) is an inter-process communication technique used for client-server based applications; it is used to communicated with the `bitmarkd` server.

RPC calls are also called subroutine calls or function calls. 

## RPC Flow

### Initializing

When `bitmarkd` starts, it initializes RPC settings including maximum connection count, connection bandwidth, and communication encryption key. It then binds RPC on a specific port and listens to that RPC port.

### Processing Messages

Different RPC commands are processed by different functions. The following sections describes each command with examples. Each message is in JSON format: the key `method` denotes which remote method is being executed, and the  key `params` denotes what arguments are being passed.

In order to test these examples, `bitmarkd` should be started in advance at the default RPC port of `2130`. `openssl` should be installed to run communications.

All methods are named in the format of `file_name.method_name`, for example, `Assets.Get` stands for the method `Get` in the file `assets.go`.

**Available commands:**

1. `Assets.Get` - retrieve assets information

Parameters:

- fingerprints - an array of asset fingerprints

Example shell command:

```shell
(echo '{"method":"Assets.Get","params":[{"fingerprints": ["01c7499e5d27880da75a3747340aa1cb2f11fa023f7aa1eb10acbf28e447aefd366759092de7a31fdfe89fcb88ecc3c90c0e067484184f41a8e3043e8aa4732f00", "01f9c2eed799128d331c0e60b07d99bffa299b100eea7bb4a410d8f2ee2a04218623f2dbd1a53f0fe08f9cda131ecff213889cbd2cf5c8e53100581ff00f6270c1"]}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

2. `Bitmark.Provenance` - retrieve transfer history of a bitmark

Parameters:

- count - provenance depth to return
- txId - string of transaction ID

Example shell command:

```shell
(echo '{"method":"Bitmark.Provenance","params":[{"count":20,"txId":"2dc8770718b01f0205ad991bfb4c052f02677cff60e65d596e890cb6ed82c861"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

3. `Bitmark.Transfer` - transfer a bitmark

Parameter:

- link - previous transaction ID
- owner - new owner account
- signature - hex string of previous owner's signature
- countersignature - hex string of new owner's signature

Example shell command:

```shell
(echo '{"method":"Bitmark.Transfer","params":[{"link":"1bebd06c8ecb8b11ea93e93c9d38b7f6d7dfdf015530819015172cf51c7f33f7", "owner": "eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", "signature": "a3e456a31a4a64962a32bcbf6549d14134deeb5d87285a04c648355eb9e59d938f8ab440d2b50c781baf2c1a5a2112c2167301bb128c8f850a9d54f3b27c5a08"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

4. `Bitmarks.Create` - create a bitmark

The creation parameters are composed of two parts: asset and owner.

Asset Parameters:

- name - name of asset
- fingerprint - fingerprint of asset
- metadata - attributes related to an asset; each metadata attribute is composed of two parts, key and value, separated by `\u0000`. For example, to denote a key "date" with value "2001.01.01" would be `"metadata": "date\u00002001.01.01"`
- registrant - owner account
- signature - hex string of owner's signature

Owner Parameters:

- assetId - asset id
- owner - owner account
- nonce - string to ensure hash meets difficulty requirement
- signature - hex string of owner's signature

Example shell command:

```shell
(echo '{"id":"1","method":"Bitmarks.Create","params":[{"assets": [{"name": "asset", "fingerprint": "01840006653e9ac9e95117a15c915caab81662918e925de9e004f774ff82d7079a40d4d27b1b372657c61d46d470304c88c788b3a4527ad074d1dccbee5dbaa99a", "metadata": "k1\u0000v1\u0000k2\u0000v2", "registrant": "e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog", "signature": "dc9ad2f4948d5f5defaf9043098cd2f3c245b092f0d0c2fc9744fab1835cfb1ad533ee0ff2a72d1cdd7a69f8ba6e95013fc517d5d4a16ca1b0036b1f3055270c"}], "issues": [{"assetId": "3c50d70e0fe78819e7755687003483523852ee6ecc59fe40a4e70e89496c4d45313c6d76141bc322ba56ad3f7cd9c906b951791208281ddba3ebb5e7ad83436c", "owner": "e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog", "nonce": 4, "signature": "6ecf1e6d965e4364321596b4675950554b3b8f1b40be3deb64306ddf72fef09f3c6bcebd6375925a51b984f56ec751a54c88f0dab56b3f69708a7b634c428a0a"}]}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

5. `Bitmarks.Proof` - provide payment information

Parameters:

- payId - payment id
- nonce - string to ensure hash meets difficulty criteria (nonce)

Example shell command:

```shell
(echo '{"id":"1","method":"Bitmarks.Proof","params":[{"payId":"2ad3ba0b28fe98716bb8d87169a952eebfc4aff96b4f9eb7de7d4c71c7acee79", "nonce": "c114fa516a98c3de"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

6. `BlockOwner.Transfer` - transfer block ownership to another account

Parameters:

- link - transaction hash
- version - version to specify available payments
- payments - payment information
- owner - new owner
- signature - hex string of previous owner's signature
- countersignature - hex string of new owner's signature

Example shell command:

```shell
(echo '{"id":"1","method":"BlockOwner.Transfer","params":[{"link":"1bebd06c8ecb8b11ea93e93c9d38b7f6d7dfdf015530819015172cf51c7f33f7", "version": 1, "payments": {"1": "BTC-address", "2": "LTC-address"}, "owner": "eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", "signature": "a3e456a31a4a64962a32bcbf6549d14134deeb5d87285a04c648355eb9e59d938f8ab440d2b50c781baf2c1a5a2112c2167301bb128c8f850a9d54f3b27c5a08"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

7. `Node.Info` - retrieve node info

No extra parameters are needed.

Example shell command:

```shell
(echo '{"method":"Node.Info","params":[{}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

8. `Node.List` - list available nodes

Parameters:

- count - how many nodes to return

Example shell command:

```shell
(echo '{"id":"1","method":"Node.List","params":[{"count": 20}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet

```
9. `Transaction.Status` - retrieve status of a transaction

Parameters:

- txId - array of transaction hashes

Example shell command:

```shell
(echo '{"id":"1","method":"Transaction.Status","params":[{"txId":"2dc8770718b01f0205ad991bfb4c052f02677cff60e65d596e890cb6ed82c861"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```
