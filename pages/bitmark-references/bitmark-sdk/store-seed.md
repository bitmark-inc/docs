---
title: Store Seed
keywords: sdk, store seed
last_updated: 
sidebar: mydoc_sidebar
permalink: store-seed.html
folder: bitmark-references/bitmark-sdk
---

# Store Seed

Store key in mobile application is very important to ensure the security, protect user data against attackers. Bitmark SDK provides the utility for storing Account seed securely in mobile application, support **Android/iOS** platform.

## Android

Bitmark SDK Android provides `KeyAuthenticationSpec.Builder` to declare how we store/retrieve `Account` securely. The `KeyAuthenticationSpec.Builder` attributes is described following.

| Attribute | Function | Description |
| --------- | ----------- | ----------- |
| `keyAlias` | `setKeyAlias(String`) | The alias represents for the account. Each time you store `Account`, you should use different alias even in the same `Account`
| `isAuthenticationRequired` | `setAuthenticationRequired(boolean)` | Need the authentication each time store/retrieve the `Account` |
| `authenticationValidityDuration` | `setAuthenticationValidityDuration(int)` | The time frame in second that the `Account` using does not need to be authenticated each time you use it. In this mode, the authentication method is always **PIN/Password/Pattern** |
| `useAlternativeAuthentication` | `setUseAlternativeAuthentication` | Using the **PIN/Password/Pattern** as an alternative authentication method in case the device does not support biometric authentication |
| `authenticationTitle` | `setAuthenticationTitle(String)` | The title for the authentication dialog |
| `authenticationDescription` | `setAuthenticationDescription(String)` | The description for the authentication dialog |

The following describes `Exception` would be thrown.

| Exception | Description |
| --------- | ----------- |
| `AuthenticationException` | This exception let you know the corresponding behaviors from users when we do authenticate them |
| `AuthenticationRequiredException` | This exception will be returned if users didn't setup the authentication method in System Setting |
| `HardwareNotSupportedException` | This exception let you know the device does not support required hardware for authentication |

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

Bitmark Android SDK supports storing key from Android **API 23(M)** and above because of the security level.

Bitmark Android SDK would authenticate user **each time** they use the key (depend on your `KeyAuthenticationSpec`), so protects user against attackers. We use Android Key Store system with a lot of security algorithm for protecting user's key.

**NOTE**:

- You **need** to `extends StatefulActivity` in the host `Activity` you pass for storing/getting/deleting the key.
- **React Native** is also supported as an *experimental* feature. You **need** to `extends StatefulReactActivity` in the host `Activity` you want to pass for storing/getting/deleting the key.
- We use Android Key store for securely storing the `Account` so that if the key is used to encrypt `Account` is invalidated by some reasons like add/remove the fingerprint or even the key is no longer available, some official `Exception` will be thrown. For more detail, please visit [here](https://developer.android.com/training/articles/keystore).

## iOS

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

Bitmark Swift SDK uses iOS keychain to store bitmark accounts. To use this feature, on your app, you need to setup the keychain first.
Parameters:
1. `service`: your keychain service name, depends on what you configurated on your entitlement file.
2. `alias`: the key to save your account into keychain. Default value is your account number.
