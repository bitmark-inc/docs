---
title: SDK Getting Started
keywords: sdk, sdk installation, sdk configuration
last_updated: 
sidebar: mydoc_sidebar
permalink: /essentials/sdk/getting-started
folder: essentials/sdk
---

# SDK Getting Started

The Bitmark Property System is a universal property system that confers the same property rights to digital assets that have long existed for physical assets. The system records ownership claims for digital assets on the public Bitmark blockchain using digital property titles known as Bitmark certificates. These digital assets can be any sort of digital object, including files, applications, code, and data. 

In the digital world:

**digital property = digital asset + bitmark certificate (property rights)**

You can work with the Bitmark blockchain to look up Bitmark certificates or even to register and transfer digital properties using the Bitmark SDK, a collection of libraries for different programming languages and mobile platforms. In addition to providing language-specific bindings to the Bitmark APIs, the SDK also simplifies local key management for signing and encryption.

For simplicity, the term *Bitmark certificate* is shortened as *bitmark* in the SDK.

## Installing SDK Packages

The Bitmark SDK can be installed for JavaScript, Swift, Java, or Go.

{% codetabs %}
{% codetab JS %}
```javascript
$ npm install bitmark-sdk-js
```
{% endcodetab %}
{% codetab Swift %}
```swift
pod 'BitmarkSDK'
```
{% endcodetab %}
{% codetab Java %}
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
{% endcodetab %}
{% codetab Go %}
```go
$ go get github.com/bitmark-inc/bitmark-sdk-go
```
{% endcodetab %}
{% endcodetabs %}

## Acquiring an API token

An API token is required to authenticate requests to the Bitmark API.

Please contact [Bitmark support](mailto:support@bitmark.com) to create a developer account and get an API token.

## Configuring the SDK

Before working with the Bitmark blockchain, configure the SDK for your API token and the Bitmark network that you'll be using.

{% codetabs %}
{% codetab JS %}
```javascript
const sdk = require('bitmark-sdk-js');

const config = {
  apiToken: "api-token",
  network: "testnet"
};

sdk.init(config);
```
{% endcodetab %}
{% codetab Swift %}
```swift
import BitmarkSDK

BitmarkSDK.initialize(config: SDKConfig(apiToken: "api-token",
                                        network: .testnet,
                                        urlSession: URLSession.shared))
```
{% endcodetab %}
{% codetab Java %}
```java
final GlobalConfiguration.Builder builder = GlobalConfiguration.builder().withApiToken("api-token").withNetwork(Network.LIVE_NET);
BitmarkSDK.init(builder);
```
{% endcodetab %}
{% codetab Go %}
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
{% endcodetab %}
{% endcodetabs %}

Each code example in the later sections presumes that the SDK is already correctly initialized.