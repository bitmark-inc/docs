---
title: Receiving WebSocket Events
keywords: sdk, web socket
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-sdk/websocket
folder: bitmark-references/bitmark-sdk
---

# Receiving WebSocket Events
Realtime event triggering is trending in modern application development. It helps application to always be up to date and so provides better user experiences.
Bitmark SDK offers Web Socket event triggering so that the application can be notified immediately when anything changes.

## Event
- New block: Sent when the Bitmark blockchain has a new block.
  + `blockNumber` : new block number
- Bitmark changed: Sent when users issue new bitmarks, receive new bitmarks, or send them to a new owner.
  + `bitmarkId`: the id of the bitmark that changed
  + `txId`: the corresponding transaction id
  + `presence`: whether the bitmark is owned or not by the corresponding `Account`
- New transfer offer: Sent when users receive new transfer offers, for two-signatures transfer.
  + `bitmarkId`: the id of the bitmark that's offered.
- New pending issuance: Sent when users issue new bitmarks.
  + `bitmarkId` : the id of the bitmark that's issuing.
- New pending transfer: Sent when a transfer occurs, to both sender and receiver.
  + `txId`: the transaction id
  + `owner`: the recipient of this transfer
  + `prevTxId`: the previous transaction id
  + `prevOwner`: the sender who made the transfer

Note: The attribute names could be different depending on the SDK used. This document refers specifically to the Java SDK.

### Connect/Disconnect
{% codetabs %}
{% codetab Java %}
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
{% endcodetab %}
{% codetab Swift %}
```swift
// TODO
```
{% endcodetab %}
{% endcodetabs %}


### Subscribe/Unsubscribe
{% codetabs %}
{% codetab Java %}
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
{% endcodetab %}
{% codetab Swift %}
```swift
// TODO
```
{% endcodetab %}
{% endcodetabs %}
