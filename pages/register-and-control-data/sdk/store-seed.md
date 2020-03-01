---
title: Storing a Seed
keywords: sdk, store seed
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-sdk/store-seed
folder: bitmark-references/bitmark-sdk
---

# Storing a Seed

Storing your `Account` using a mobile application is very important to ensure its security and to protect your user data against attackers. Bitmark SDK supports storing your Account seed securely in mobile applications on both the **Android** and **iOS** platforms.

_Unlike other SDK documents, which cover Go, Java, JavaScript, and Swift, this document only describes the SDK for mobile platforms: Java for Android and Swift for iOS._

## Android

The Android Bitmark SDK  provides `KeyAuthenticationSpec.Builder` for storing and retrieving `Account` securely. 

`KeyAuthenticationSpec.Builder` possesses the following attributes:

| Attribute | Function | Description |
| --------- | ----------- | ----------- |
| `keyAlias` | `setKeyAlias(String`) | An alias representing the account. Each time you store an `Account`, you should use a different alias, even for the same `Account` |
| `isAuthenticationRequired` | `setAuthenticationRequired(boolean)` | Whether authentication is required each time you store or retrieve the `Account` |
| `authenticationValidityDuration` | `setAuthenticationValidityDuration(int)` | The time frame in seconds during which the `Account` will not need to be authenticated again. In this mode, the authentication method is always **PIN/Password/Pattern** |
| `useAlternativeAuthentication` | `setUseAlternativeAuthentication` | Whether to use **PIN/Password/Pattern** as an alternative authentication method in case the device does not support biometric authentication |
| `authenticationTitle` | `setAuthenticationTitle(String)` | The title for the authentication dialog |
| `authenticationDescription` | `setAuthenticationDescription(String)` | The description for the authentication dialog |

The following `Exception`s might be thrown by `KeyAuthenticationSpec.Builder`:

| Exception | Description |
| --------- | ----------- |
| `AuthenticationException` | This exception describes the corresponding behavior from users when they are authenticated |
| `AuthenticationRequiredException` | This exception is returned if users didn't setup the authentication method in System Setting |
| `HardwareNotSupportedException` | This exception states that the device does not support the required hardware for authentication |

```java
// Storing your account
final Account account = new Account();
final KeyAuthenticationSpec spec = new KeyAuthenticationSpec.Builder(getApplicationContext())
                     .setKeyAlias(ENCRYPTION_KEY_ALIAS)
                     .setAuthenticationRequired(true)
                     .setAuthenticationValidityDuration(100)
                     .setAuthenticationTitle("Title")
                     .setAuthenticationDescription("Description")
                     .setUseAlternativeAuthentication(true)
                     .build();

account.saveToKeyStore(activity, alias, spec, new Callback0() {
                @Override
                public void onSuccess() {

                }

                @Override
                public void onError(Throwable throwable) {

                }
            });

// Getting your account
final KeyAuthenticationSpec spec = new KeyAuthenticationSpec.Builder(getApplicationContext())
                      .setKeyAlias(ENCRYPTION_KEY_ALIAS)
                      .build();
Account.loadFromKeyStore(activity, alias, spec, new Callback1<Account>() {
                @Override
                public void onSuccess(Account account) {

                }

                @Override
                public void onError(Throwable throwable) {

                }
            });

// Deleting your account
final KeyAuthenticationSpec spec = new KeyAuthenticationSpec.Builder(getApplicationContext())
                                        .setKeyAlias(ENCRYPTION_KEY_ALIAS)
                                        .build();
account.removeFromKeyStore(activity, spec, new Callback0() {
                @Override
                public void onSuccess() {

                }

                @Override
                public void onError(Throwable throwable) {

                }
            });

```

Bitmark Android SDK supports storing keys from Android **API 23(M)** and above because of the security level.

Bitmark Android SDK would authenticate the user **each time** they use the key (depend on the `KeyAuthenticationSpec` setting) to protect the user against attackers. The SDK uses the Android Key Store system with a lot of security algorithm for protecting the user's key.

**NOTE**:

- You **need** to `extends StatefulActivity` in the host `Activity` you pass for storing, retrieving, or deleting the key.
- **React Native** is also supported as an *experimental* feature. You **need** to `extends StatefulReactActivity` in the host `Activity` you want to pass for storing, retrieving, or deleting the key.
- We use Android Key store for securely storing the `Account` so that if the key used to encrypt `Account` is invalidated by some method, such as adding or removing the fingerprint, or even if the key is no longer available, some official `Exception` will be thrown. For more details, please visit [Android's article on keystore](https://developer.android.com/training/articles/keystore).

## iOS

Bitmark Swift SDK uses iOS keychain to store bitmark accounts. To use this feature, on your app, you need to setup the keychain first.

| Parameter | Description |
| `service` | your keychain service name; dependent on what is configured in the entitlement file |
| `alias` | the key to save your account into keychain; default value is your account number |

```swift
// Storing your account
try account.saveToKeychain(service: "com.bitmarksdk.example",
                            alias: "bitmark-account",
                            requireAuthenticationWithMessage: nil)

// Getting your account
try Account.loadFromKeychain(service: "com.bitmarksdk.example",
                                alias: "bitmark-account",
                                requireAuthenticationWithMessage: nil)
```

