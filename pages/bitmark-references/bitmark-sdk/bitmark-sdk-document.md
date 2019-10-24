---
title: Action
keywords: sdk, sdk doc
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-sdk/bitmark-sdk-document
folder: bitmark-references/bitmark-sdk
---

# Overview

The Bitmark property system is an universal property system for conferring the same property rights to digital assets that have long existed for physical assets. This system records ownership claims for digital assets as digital property titles known as bitmark certificates on the Bitmark public blockchain. A digital asset can be any digital object, including files, applications, code, and data. In the digital world:

**digital property = digital asset + bitmark certificate (property rights)**

For simplicity, *bitmark certificate* is shorten as *bitmark* in SDK design.

You can work with the Bitmark blockchain to look up Bitmark certificates or even register and transfer digital properties using the Bitmark SDK, a collection of libraries for different programming languages and mobile platforms. In addition to providing language-specific bindings to the Bitmark APIs, the SDK also simplifies local key management for signing and encryption.

# Getting Started

## Installation

```javascript
npm install bitmark-sdk-js
```

```swift
pod 'BitmarkSDK'
```

```java
// From your build.gradle
repositories {
    jcenter()
    maven { url 'https://oss.sonatype.org/content/repositories/snapshots/' } // For snapshot version
}

dependencies {
    implementation 'com.bitmark.sdk:java-sdk:2.1.0' // Java SDK
    // Or
    implementation 'com.bitmark.sdk:android-sdk:2.1.0' // Android SDK
}
```

```go
go get github.com/bitmark-inc/bitmark-sdk-go
```

## Get your API token

The API token is required to authenticate your requests to the Bitmark API.

Please contact our [support](mailto:support@bitmark.com) to create your developer account and get the API token.

## Configuration

Before working with the Bitmark blockchain, you'll need to configure the SDK for your API token and the Bitmark network that you'll be using.

Every code example in other sections presumes the SDK is already correctly initialized.

```javascript
const sdk = require('bitmark-sdk-js');

const config = {
  apiToken: "api-token",
  network: "testnet"
};

sdk.init(config);
```

```swift
import BitmarkSDK

BitmarkSDK.initialize(config: SDKConfig(apiToken: "api-token",
                                        network: .testnet,
                                        urlSession: URLSession.shared))
```

```java
final GlobalConfiguration.Builder builder = GlobalConfiguration.builder().withApiToken("api-token").withNetwork(Network.LIVE_NET);
BitmarkSDK.init(builder);
```

```go
import sdk "github.com/bitmark/bitmark-inc/bitmark-sdk-go"

func main() {
	config := &sdk.Config{
		APIToken: "YOUR API TOKEN",
		Network:  sdk.Testnet,
		HTTPClient: &http.Client{
			Timeout: 10 * time.Second,
		},
	}
	sdk.Init(config)
}
```
