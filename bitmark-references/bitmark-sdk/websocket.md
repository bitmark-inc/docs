# Web Socket
Realtime event triggering is trending in modern application development nowadays. It helps the application is always up to date and so provides better user experience.
Bitmark SDK offers Web Socket event triggering to help the application can be notified immediately when there are anything changes.

## Event
- New block: This event will be sent when bitmark blockchain has a new block.
  + `blockNumber` : new block number
- Bitmark changed: This event will be sent when users issue new bitmarks, received new bitmarks, or send them to new owner.
  + `bitmarkId`: the id of bitmark is changed
  + `txId`: the corresponding transaction id
  + `presence`: indicate that the bitmark is owned or not by the corresponding `Account`
- New transfer offer: This event will be sent when users receive new transfer offer (for 2 signatures transfer) from someone.
  + `bitmarkId`: the id of bitmark is comming
- New pending issuance: This event will be sent when users issue new bitmarks.
  + `bitmarkId` : the id of bitmark is issuing
- New pending transaction: This event will be sent to both sender and receiver.
  + `txId`: the id of this pending transaction
  + `owner`: the current owner of corresponding bitmark
  + `prevTxId`: the previous id of this transaction
  + `prevOwner`: the previous owner of corresponding bitmark

Note: The attributes name is the sample from Bitmark Java SDK. There are something different in Swift SDK but the meaning is the same.

## Java

#### Connect/Disconnect
```java
WebSocket.ConnectionEvent connEvent = new WebSocket.ConnectionEvent() {
            @Override
            public void onConnected() {

            }

            @Override
            public void onDisconnected() {

            }

            @Override
            public void onConnectionError(Throwable e) {

            }
        }
BitmarkWebSocket ws = new BitmarkWebSocketService();

// connect
ws.connect(authKeyPair);

// disconnect
ws.disconnect();
```
#### Subscribe/Unsubscribe
```java
// subscribe
ws.subscribeBitmarkChanged(
                address,
                new BitmarkWebSocket.BitmarkChangedEvent() {

                    @Override
                    public void onChanged(
                            String bitmarkId,
                            String txId,
                            boolean presence
                    ) {

                    }

                    @Override
                    public void onSubscribeSuccess(SubscribeSuccessEvent event) {

                    }

                    @Override
                    public void onSubscribeError(SubscribeErrorEvent event) {

                    }
                }
        );

// unsubscribe
ws.unsubscribeBitmarkChanged(address);
```


## Swift
