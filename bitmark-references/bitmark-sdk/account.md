# Account

Within the Bitmark system, an account represents any entity capable of creating and owning property, whether individuals, institutions, or organizations. 

An account incorporates the public-private key-pair and the private key is required to [digitally sign](https://en.wikipedia.org/wiki/Digital_signature) any Bitmark blockchain record, including asset records, issue records, and transfer records.

## Create an account

```javascript
let account = new sdk.Account();

// or
const Account = sdk.Account;
let account = new Account();

```

```swift
let account = try Account() // default will be version 1

// or we can create bitmark account v2

let account = try Account(version: .v2, network: .testnet)
```

```java
Account account = new Account();
```

```go
acct, err := account.New()
```

## Get the account number

```javascript
let accountNumber = account.getAccountNumber();
// ffzcoJeg7p6kJrV6VNhS6juuceTCKMmek1WrXopvbzNTvYqANy
```

```swift
let accountNumber = account.accountNumber()
// ffzcoJeg7p6kJrV6VNhS6juuceTCKMmek1WrXopvbzNTvYqANy
```

```java
String accountNumber = account.getAccountNumber();
```

```go
acct, _ := account.New()
accountNumber := acct.AccountNumber()
```

The account number of an account serves as a pseudonymous identifier within the Bitmark blockchain, which can represent:

- **registrant** of an asset
- **owner** of a bitmark
- **sender** of a bitmark transfer offer
- **receiver** of a bitmark transfer offer

## Export an account

We provide two formats for exporting an account: **seed** and **recovery phrase**, both of which store all the required information to instantiate an account.

<aside class="warning">
Because seed and recovery phrase is the "ticket" that allows someone to control properties under an account, it is important they are kept secure.
</aside>

### Seed

```javascript
let seed = account.getSeed();
// 9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8
```

```swift
let seed = try account.toSeed()
// 5XEECttvVsk5xPjZ1zrgtWoauw2xmPwTKCWEN5GF24UpaGZhAGS6tXd
```

```java
Seed seed = account.getSeed();
String encodedSeed = seed.getEncodedSeed();
// 9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8
```

```go
acct, _ := account.New()
seed := acct.Seed()
```

The seed is the more compact format of an exported account for your program to re-instantiate an account.

### Recovery Phrase

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

```swift
// English version
let phrase = try account.getRecoverPhrase(language: .english)

// Tranditional Chinese version
let phrase = try account.getRecoverPhrase(language: .chineseTraditional)
```

```java
// English ver
RecoveryPhrase recoveryPhrase = account.getRecoveryPhrase();
// Or
RecoveryPhrase recoveryPhrase = account.getRecoveryPhrase(Locale.ENGLISH);

String[] mnemonicWords = recoveryPhrase.getMnemonicWords();
// ["name", "gaze", "apart", "lamp", "lift", "zone",
//  "believe", "steak", "session", "laptop", "crowd", "hill"]

// Chinese ver
RecoveryPhrase recoveryPhrase = account.getRecoveryPhrase(Locale.CHINESE);
String[] mnemonicWords = recoveryPhrase.getMnemonicWords();
// ["箱", "阻", "起", "归", "彻", "矮", "问", "栽", "瓜", "鼓", "支", "乐"]
```

```go
acct, _ := account.New()
phrase, err := acct.RecoveryPhrase(language.AmericanEnglish)
```

The recovery phrase, which consists of 12 [mnemonic words](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki), is superior for human interaction compared to the handling of seed. If you don't plan to custody user's private key, make sure you present the recovery phrase to your user. Currently English and traditional Chinese phrases are supported.

## Import an account

On the contrast, there are functions for you to recover the accounts.

### Recover from seed

```javascript
let account = Account.fromSeed("9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8");
```

```swift
account = Account(fromSeed: "5XEECttvVsk5xPjZ1zrgtWoauw2xmPwTKCWEN5GF24UpaGZhAGS6tXd")
```

```java
// 12 words
Seed seed = SeedTwelve.fromEncodedSeed("9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8");

// 24 words
Seed seed = SeedTwentyFour.fromEncodedSeed("5XEECt18HGBGNET1PpxLhy5CsCLG9jnmM6Q8QGF4U2yGb1DABXZsVeD");

Account account = Account.fromSeed(seed);
```

```go
acct, err := account.FromSeed("9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8")
```

### Recover from phrase

```javascript
// English version
let account = Account.fromRecoveryPhrase("name gaze apart lamp lift zone believe steak session laptop crowd hill");
// or
let account = Account.fromRecoveryPhrase("name gaze apart lamp lift zone believe steak session laptop crowd hill", "en");


// Chinese version
let account = Account.fromRecoveryPhrase("箱 阻 起 归 彻 矮 问 栽 瓜 鼓 支 乐", "cn");
```

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

```java
Account account = Account.fromRecoveryPhrase("name", "gaze", "apart", "lamp", "lift", "zone", "believe", "steak", "session", "laptop", "crowd", "hill"); // English

// Or 
Account account = Account.fromRecoveryPhrase("箱", "阻", "起", "归", "彻", "矮", "问", "栽", "瓜", "鼓", "支", "乐"); // Chinese

```

```go
acct, err := account.FromRecoveryPhrase(
    []string{
        "name", "gaze", "apart", "lamp", " lift", " zone",
        "believe", "steak", "session", "laptop", "crowd", "hill",
    },
    language.AmericanEnglish,
)
```

## Sign and Verify

An account can be used to sign arbitrary message, and any party with the received message and the corresponding signature can validate if the message was created by a known sender (authentication), and the message was not altered in transit (integrity). This functionality is usually useful when you have a server application which needs to authenticate if the requests are from valid users.

```javascript
// TODO
```

```swift
// TODO
```

```java
// TODO
```

```go
// client side
acct, _ := account.FromSeed("YOUR SEED")

msg := []byte("Hello, world!")
sig := acct.Sign(msg)

// server side can verify if the message is from the client and 
err := account.Verify(acct.AccountNumber(), msg, sig)
```

## Account utility functions

Here are some are some helper functions.

### Validate account number

```javascript
let isValid = Account.isValidAccountNumber(accountNumber);
```

```swift
let isValid = Account.isValidAccountNumber(accountNumber)
```

```java
boolean isValid = Account.isValidAccountNumber(accountNumber);
```

```go
err := account.ValidateAccountNumber("e1pFRPqPhY2gpgJTpCiwXDnVeouY9EjHY6STtKwdN6Z4bp4sog")
```

The function returns an error to indicate whether a given account number is valid in current runtime environment, i.e.,
the format is correct and its network matches to the network specified in the SDK config during initialization.
