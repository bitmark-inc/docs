---
title: Account
keywords: account, sdk
last_updated: 
sidebar: mydoc_sidebar
permalink: /bitmark-references/bitmark-sdk/account
folder: bitmark-references/bitmark-sdk
---

# Account

Within the Bitmark Property System, an account represents any entity capable of creating and owning property, whether individuals, institutions, or organizations.

An account incorporates the public-private key-pair; the private key is needed to [digitally sign](https://en.wikipedia.org/wiki/Digital_signature) any Bitmark blockchain record, including asset records, issue records, and transfer records.

## Creating an account

You must create a new identity to participate on the Bitmark blockchain.

{% codetabs %}
{% codetab JS %}
```javascript
let account = new sdk.Account();

// or
const Account = sdk.Account;
let account = new Account();

```
{% endcodetab %}
{% codetab Swift %}
```swift
let account = try Account()
```
{% endcodetab %}
{% codetab Java %}
```java
Account account = new Account();
```
{% endcodetab %}
{% codetab Go %}
```go
acct, err := account.New()
```
{% endcodetab %}
{% endcodetabs %}

## Retrieving the account number

The account number of an account serves as a pseudonymous identifier within the Bitmark blockchain. It can represent:

- The **registrant** of an asset
- The **owner** of a bitmark
- The **sender** of a bitmark transfer offer
- The **receiver** of a bitmark transfer offer

{% codetabs %}
{% codetab JS %}
```javascript
let accountNumber = account.getAccountNumber();
// ffzcoJeg7p6kJrV6VNhS6juuceTCKMmek1WrXopvbzNTvYqANy
```
{% endcodetab %}
{% codetab Swift %}
```swift
let accountNumber = account.accountNumber()
// ffzcoJeg7p6kJrV6VNhS6juuceTCKMmek1WrXopvbzNTvYqANy
```
{% endcodetab %}
{% codetab Java %}
```java
String accountNumber = account.getAccountNumber();
```
{% endcodetab %}
{% codetab Go %}
```go
acct, _ := account.New()
accountNumber := acct.AccountNumber()
```
{% endcodetab %}
{% endcodetabs %}

## Exporting an account

There are two formats for exporting an account: **seed** and **recovery phrase**, both of which store all the required information to instantiate an account.

Both the seed and the recovery phrase can be used to derive the original private key of an account, so it is critical to store them securely.

### Exporting a seed

The seed is the more compact format of an exported account. See [Store seed](store-seed.md) to learn how to securely store seeds in mobile phones.

{% codetabs %}
{% codetab JS %}
```javascript
let seed = account.getSeed();
// 9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8
```
{% endcodetab %}
{% codetab Swift %}
```swift
let seed = try account.toSeed()
// 5XEECttvVsk5xPjZ1zrgtWoauw2xmPwTKCWEN5GF24UpaGZhAGS6tXd
```
{% endcodetab %}
{% codetab Java %}
```java
Seed seed = account.getSeed();
String encodedSeed = seed.getEncodedSeed();
// 9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8
```
{% endcodetab %}
{% codetab Go %}
```go
acct, _ := account.New()
seed := acct.Seed()
```
{% endcodetab %}
{% endcodetabs %}

### Exporting a recovery phrase

The recovery phrase, which consists of twelve [mnemonic words](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki), is superior to the seed for human interaction. If you don't maintain custody of the seeds of your users, make sure you present the recovery phrase to them and teach them [how to store it in a secure place](https://help.trustwallet.com/hc/en-us/articles/360016509753-Best-Practices-for-Storing-Your-Recovery-Phrase). 

Currently English and traditional Chinese phrases are supported.

{% codetabs %}
{% codetab JS %}
```javascript
// English version
let recoveryPhrase = account.getRecoveryPhrase();
// or
let recoveryPhrase = account.getRecoveryPhrase("en");
// "name gaze apart lamp lift zone believe steak session laptop crowd hill"

// Chinese version
let recoveryPhrase = account.getRecoveryPhrase("cn");
// "箱 阻 起 归 彻 矮 问 栽 瓜 鼓 支 乐"
```
{% endcodetab %}
{% codetab Swift %}
```swift
// English version
let phrase = try account.getRecoverPhrase(language: .english)

// Traditional Chinese version
let phrase = try account.getRecoverPhrase(language: .chineseTraditional)
```
{% endcodetab %}
{% codetab Java %}
```java
// English ver
RecoveryPhrase recoveryPhrase = account.getRecoveryPhrase();
// Or
RecoveryPhrase recoveryPhrase = account.getRecoveryPhrase(Locale.ENGLISH);

String[] mnemonicWords = recoveryPhrase.getMnemonicWords();
// ["name", "gaze", "apart", "lamp", "lift", "zone",
//  "believe", "steak", "session", "laptop", "crowd", "hill"]

// Chinese ver
RecoveryPhrase recoveryPhrase = account.getRecoveryPhrase(Locale.TRADITIONAL_CHINESE);
String[] mnemonicWords = recoveryPhrase.getMnemonicWords();
// ["箱", "阻", "起", "归", "彻", "矮", "问", "栽", "瓜", "鼓", "支", "乐"]
```
{% endcodetab %}
{% codetab Go %}
```go
acct, _ := account.New()
phrase, err := acct.RecoveryPhrase(language.AmericanEnglish)
```
{% endcodetab %}
{% endcodetabs %}

## Importing an account

As mentioned in [Exporting an account](#exporting-an-account), an account could be exported as either a `seed` or a `recovery phrase`, so there are two corresponding functions to recover an account from the supported exported formats.

### Recovering from a seed

To instantiate an account from a given seed:

{% codetabs %}
{% codetab JS %}
```javascript
let account = Account.fromSeed("9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8");
```
{% endcodetab %}
{% codetab Swift %}
```swift
account = Account(fromSeed: "5XEECttvVsk5xPjZ1zrgtWoauw2xmPwTKCWEN5GF24UpaGZhAGS6tXd")
```
{% endcodetab %}
{% codetab Java %}
```java
Account account = Account.fromSeed("9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8");
```
{% endcodetab %}
{% codetab Go %}
```go
acct, err := account.FromSeed("9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8")
```
{% endcodetab %}
{% endcodetabs %}

### Recovering from a phrase

To instantiate an account from a given recovery phrase:

{% codetabs %}
{% codetab JS %}
```javascript
// English version
let account = Account.fromRecoveryPhrase("name gaze apart lamp lift zone believe steak session laptop crowd hill");
// or
let account = Account.fromRecoveryPhrase("name gaze apart lamp lift zone believe steak session laptop crowd hill", "en");


// Chinese version
let account = Account.fromRecoveryPhrase("箱 阻 起 归 彻 矮 问 栽 瓜 鼓 支 乐", "cn");
```
{% endcodetab %}
{% codetab Swift %}
```swift
// English version
let account = try Account(recoverPhrase: [
    "music", "life", "stone", "brain", "slush", "mango",
     "diagram", "business", "dumb", "cinnamon", "coral", "year"],
    language: .english
)

// Traditional Chinese version
let account = try Account(recoverPhrase: [
    "婆", "潮", "睛", "毫", "壤", "殿", "北", "謝", "人", "答", "隊", "星"],
    language: .chineseTraditional
)
```
{% endcodetab %}
{% codetab Java %}
```java
Account account = Account.fromRecoveryPhrase("name", "gaze", "apart", "lamp", "lift", "zone", "believe", "steak", "session", "laptop", "crowd", "hill"); // English

// Or
Account account = Account.fromRecoveryPhrase("箱", "阻", "起", "归", "彻", "矮", "问", "栽", "瓜", "鼓", "支", "乐"); // Chinese

```
{% endcodetab %}
{% codetab Go %}
```go
acct, err := account.FromRecoveryPhrase(
    []string{
        "name", "gaze", "apart", "lamp", " lift", " zone",
        "believe", "steak", "session", "laptop", "crowd", "hill",
    },
    language.AmericanEnglish,
)
```
{% endcodetab %}
{% endcodetabs %}

## Signing and verifying

An account can be used to sign an arbitrary message. Any party with the received message and the corresponding signature can then validate if the message was created by a known sender (authentication) and that the message was not altered in transit (integrity). This functionality is usually useful when you have a server application that needs to authenticate whether requests are from valid users.

{% codetabs %}
{% codetab JS %}
```javascript
let account = new Account();
let message = "Hello, world!"; // message could be either string or buffer
let signature = account.sign(message); // signature is a buffer

let accountNumber = account.getAccountNumber();
let isAuthentic = Account.verify(accountNumber, message, signature);
```
{% endcodetab %}
{% codetab Swift %}
```swift
account := try Account()

// create a signature
let message = "Hello, world!".data(using: .utf8)!
let signature = try account.sign(message: message)

// verify the signature from other side
let senderAccountNumber = account.address
let isAuthentic = senderAccountNumber.verify(message: message, signature: signature)
```
{% endcodetab %}
{% codetab Java %}
```java
final Account account = new Account();
final accountNumber = account.getAccountNumber();
final message = "Hello, world!".getBytes();

// sign
byte[] signature = account.sign(message);

// verify
boolean verified = Account.verify(accountNumber, signature, message);

```
{% endcodetab %}
{% codetab Go %}
```go
// client side
acct, _ := account.FromSeed("YOUR SEED")

msg := []byte("Hello, world!")
sig := acct.Sign(msg)

// server side can verify if the message is from the client and
err := account.Verify(acct.AccountNumber(), msg, sig)
```
{% endcodetab %}
{% endcodetabs %}

## Validating an account number

Validating a given account number verifies that it is valid in the current runtime environment (i.e.,
the format is correct and its network matches the network specified in the SDK config during initialization). The SDK functions return an error if the validation fails.

{% codetabs %}
{% codetab JS %}
```javascript
let isValid = Account.isValidAccountNumber(accountNumber);
```
{% endcodetab %}
{% codetab Swift %}
```swift
let isValid = Account.isValidAccountNumber(accountNumber)
```
{% endcodetab %}
{% codetab Java %}
```java
boolean isValid = Account.isValidAccountNumber(accountNumber);
```
{% endcodetab %}
{% codetab Go %}
```go
err := account.ValidateAccountNumber("e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog")
```
{% endcodetab %}
{% endcodetabs %}
