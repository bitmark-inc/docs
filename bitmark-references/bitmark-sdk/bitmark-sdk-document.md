# Overview

The Bitmark property system is an universal property system for conferring the same property rights to digital assets that have long existed for physical assets. This system records ownership claims for digital assets as digital property titles known as bitmarks on the Bitmark public blockchain. A digital asset can be any digital object, including files, applications, code, and data. In the digital world:

**digital property = digital asset + bitmark**

The Bitmark SDK enables creation, transfer, and authentication of digital properties in the Bitmark property system. The SDK's simplified interface allows developers to easily build on the core Bitmark infrastructure by reading from and writing to the Bitmark blockchain.

# Getting Started

## Installation

```javascript
npm install bitmark-sdk
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
    implementation 'com.bitmark.sdk:java-sdk:1.5' // Java SDK
    // Or
    implementation 'com.bitmark.sdk:android-sdk:1.4' // Android SDK
}
```

```go
go get github.com/bitmark-inc/bitmark-sdk-go@v0.2.1
```

## Get your API token

The API token is required to authenticate your requests to the Bitmark API.

Please contact our [support](mailto:support@bitmark.com) to create your developer account and get the API token.

## Initialize

### Configuration

```javascript
const sdk = require('bitmark-sdk');

const config = {
  API_token: "api-token",
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

```java
BitmarkSDK.init("api-token");
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

	// Every example assumes the SDK is already correctly initialized
}
```

<aside class="notice">
You need to replace <code>api-token</code> with your personal API token.
</aside>