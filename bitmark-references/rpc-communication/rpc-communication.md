# RPC

## Introduction

RPC is the abbreviation of remote procedure call, which is an interprocess communication technique used for client-server based applications. It is also known as subroutine call or function call.

A client has a request message that the RPC translates and sends to the server. This request may be a procedure or a function call to a remote server. When the server receives the request, it sends the required response back to the client. The client is blocked while the server is processing the call and only resumed execution after the server is finished.

The sequence of events in a remote procedure call are given as follows:

1. Client initiates a RPC procedure call
1. Client makes a system call to send the message to the server and puts parameters in the message
1. Message is sent from client to server by client's operating system
1. Message is passed to server by the server's operating system
1. Server executes procedure call with provided parameters
1. After server finished executing, sends reponse back to client
1. Client receives response from server

# Flow

## Initialization

When `bitmarkd` starts, it initialises rpc settings including maximum connection count, connection bandwidth, communication encryption key, binds RPC on specific port, listen rpc port.

## Processing Messages

Different rpc command is processed by differnet function, following sections describes each command with examples. Each message is in json format, with one key `method` to denote which remote method to be executed, and the other key `params` to denote what arguments are passed.

In order to test examples, `bitmarkd` should be started in advance, default rpc port is on `2130`. `openssl` should be installed to run communication.

All methods are named in the format of `file_name.method_name`, for example, `Assets.Get` stands for method `Get` in file `assets.go`.

Available commands:

1. Assets.Get - retrieve assets information

It is necessary to provide asset fingerprints to query asset information, multiple assets information can be retrieved in a rpc call.

Example shell command:

```shell
(echo '{"method":"Assets.Get","params":[{"fingerprints": ["01c7499e5d27880da75a3747340aa1cb2f11fa023f7aa1eb10acbf28e447aefd366759092de7a31fdfe89fcb88ecc3c90c0e067484184f41a8e3043e8aa4732f00", "01f9c2eed799128d331c0e60b07d99bffa299b100eea7bb4a410d8f2ee2a04218623f2dbd1a53f0fe08f9cda131ecff213889cbd2cf5c8e53100581ff00f6270c1"]}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

1. Bitmark.Provenance - retrieve transfer history of a bitmark

In order to get provenance (asset transfer history), two arguments need to be provided, one is number of history to get (count), the other is transaction ID (txID).

Example shell command:

```shell
(echo '{"method":"Bitmark.Provenance","params":[{"count":20,"txId":"2dc8770718b01f0205ad991bfb4c052f02677cff60e65d596e890cb6ed82c861"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

1. Bitmark.Transfer - transfer a bitmark

To transfer a bitmark, some data is needed: previous transaction hash (link), next owner account (owner), previous hex string of owner (signature), next hex string of owner (countersignature).

Example shell command:

```shell
(echo '{"id":"1","method":"Bitmark.Transfer","params":[{"link":"1bebd06c8ecb8b11ea93e93c9d38b7f6d7dfdf015530819015172cf51c7f33f7", "owner": "eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", "signature": "a3e456a31a4a64962a32bcbf6549d14134deeb5d87285a04c648355eb9e59d938f8ab440d2b50c781baf2c1a5a2112c2167301bb128c8f850a9d54f3b27c5a08"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

1. Bitmarks.Create - create a bitmark

A bitmark is to represent property ownership, it is composed of two parts: asset and owner.

Asset data includes name of asset (name), fingerprint of asset (fingerprint), some attributes to note an asset (metadata), owner accoutn (registrant), and hext string of account (signature).

Each attribute of metadata is composed of two parts, key and value, separated by `\u0000`. For example, to denote a key "date" to have value "2001.01.01" is as "metadata": "date\u00002001.01.01".

Owner data includes asset id (assetID), account of owner (owner), string to make hash meets difficulty requirement (nonce), and hex string of account (signature).

Example shell command:

```shell
(echo '{"id":"1","method":"Bitmarks.Create","params":[{"assets": [{"name": "asset", "fingerprint": "01840006653e9ac9e95117a15c915caab81662918e925de9e004f774ff82d7079a40d4d27b1b372657c61d46d470304c88c788b3a4527ad074d1dccbee5dbaa99a", "metadata": "k1\u0000v1\u0000k2\u0000v2", "registrant": "e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog", "signature": "dc9ad2f4948d5f5defaf9043098cd2f3c245b092f0d0c2fc9744fab1835cfb1ad533ee0ff2a72d1cdd7a69f8ba6e95013fc517d5d4a16ca1b0036b1f3055270c"}], "issues": [{"assetId": "3c50d70e0fe78819e7755687003483523852ee6ecc59fe40a4e70e89496c4d45313c6d76141bc322ba56ad3f7cd9c906b951791208281ddba3ebb5e7ad83436c", "owner": "e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog", "nonce": 4, "signature": "6ecf1e6d965e4364321596b4675950554b3b8f1b40be3deb64306ddf72fef09f3c6bcebd6375925a51b984f56ec751a54c88f0dab56b3f69708a7b634c428a0a"}]}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

1. Bitmarks.Proof - provide payment information

Payment informatin includes payment id (payId) and string to make hash meets difficulty criteria (nonce).

Example shell command:

```shell
(echo '{"id":"1","method":"Bitmarks.Proof","params":[{"payId":"2ad3ba0b28fe98716bb8d87169a952eebfc4aff96b4f9eb7de7d4c71c7acee79", "nonce": "c114fa516a98c3de"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

1. BlockOwner.Transfer - transfer block ownership to another account

Some data is needed to transfer block ownership, including transaction hash (link), payment version (version), payment information (payments), next owner (owner), hex string of

Example shell command:

```shell
(echo '{"id":"1","method":"BlockOwner.Transfer","params":[{"link":"1bebd06c8ecb8b11ea93e93c9d38b7f6d7dfdf015530819015172cf51c7f33f7", "version": 5, "payments": ["1": "BTC"], "owner": "eZpG6Wi9SQvpDatEP7QGrx6nvzwd6s6R8DgMKgDbDY1R5bjzb9", "signature": "a3e456a31a4a64962a32bcbf6549d14134deeb5d87285a04c648355eb9e59d938f8ab440d2b50c781baf2c1a5a2112c2167301bb128c8f850a9d54f3b27c5a08"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

1. Node.Info

This method is in file `rpc/node.go#77: Info`. It is used to get
node info.

There no need to have any parameter for this method.

Example shell command:

```shell
(echo '{"id":"1","method":"Node.Info","params":[{}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

1. Node.List

Lists the RPC services available in the network.

Example shell command:

```shell
(echo '{"id":"1","method":"Node.List","params":[{}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```

1. Transaction.Status

This method is in file `rpc/transaction.go#32: Status`. It is used
to get transaction status.

Input format `TransactionArguments` includes string (`txId`)

```go
    type TransactionArguments struct {
        TxId merkle.Digest `json:"txId"`
    }
```

Example shell command:

```shell
(echo '{"id":"1","method":"Transaction.Status","params":[{"txId":"2dc8770718b01f0205ad991bfb4c052f02677cff60e65d596e890cb6ed82c861"}]}'; sleep 0.5; echo Q) | openssl s_client -connect 127.0.0.1:2130 -quiet
```
