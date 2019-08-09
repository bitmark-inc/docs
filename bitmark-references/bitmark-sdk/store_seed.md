# Store Seed

Store key in mobile application is very important to ensure the security, protect user data against attackers. **Bitmark** is a blockchain platform, everything is decentralized, so we need to keep the user's key more secure to guarantee the ownership. So we provide the utility for storing key securely in mobile application, support **Android/iOS** platform.

## Android

```java
// Storing your account
final Account account = new Account();
final KeyAuthenticationSpec spec = new KeyAuthenticationSpec.Builder(getApplicationContext()).setKeyAlias(ENCRYPTION_KEY_ALIAS) // The encryption key alias for encrypting your key
                                                 .setAuthenticationRequired(authentication) // true mean the key need to authenticate before using
                                                 .setAuthenticationValidityDuration(100) //  Time for keeping the key is authenticated
                                                 .setAuthenticationTitle("Title")
                                                 .setAuthenticationDescription("Description")
                                                 .build();

account.saveToKeyStore(activity/* the activity that is instance of StatefulActivity*/, alias /* the account alias, avoid it with default account number*/, spec, new Callback0() {
                @Override
                public void onSuccess() {
                    
                }

                @Override
                public void onError(Throwable throwable) {
                    
                }
            });

// Getting your account
final KeyAuthenticationSpec spec = new KeyAuthenticationSpec.Builder(getApplicationContext())
                                        .setKeyAlias(ENCRYPTION_KEY_ALIAS).build();
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

Bitmark Android SDK will authenticate user **each time** they use the key (depend on your `KeyAuthenticationSpec`), so protects user against attackers. We use Android Key Store system with a lot of security algorithm for protecting user's key. 

**NOTE**: 

- You **need** to `extends StatefulActivity` in the host activity you pass for storing/getting/deleting the key.
- **React Native** is also supported as the *experimental*. You **need** to `extends StatefulReactActivity` in the host activity you want to pass for storing/getting/deleting the key.
- Some exception will be thrown if you missed some handling such as lock screen required, fingerprint enrolled required, etc...

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