# Account

Within the Bitmark system, an account represents any entity capable of creating and owning property, whether individuals, insitutions, or organizations. 

An account incorporates the public-private keypair and the private key is required to [digitally sign](https://en.wikipedia.org/wiki/Digital_signature) any Bitmark blockchain record, including asset records, issue records, and transfer records.

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
import "github.com/bitmark-inc/bitmark-sdk-go/account"

func createNewAccountExample() {
    account, err := account.New()
}
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
import "github.com/bitmark-inc/bitmark-sdk-go/account"

func getAccountNumberExample(acct account.Account) {
    accountNumber := acct.AccountNumber()
}
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
import "github.com/bitmark-inc/bitmark-sdk-go/account"

func getSeedExample(acct account.Account) {
    seed := acct.Seed()
}
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
import (
    "github.com/bitmark-inc/bitmark-sdk-go/account"
    "golang.org/x/text/language"
)

func getRecoveryPhraseExample(acct account.Account) {
    phrase, err := acct.RecoveryPhrase(language.AmericanEnglish)
}
```

The recovery phrase, which consists of 12 [mnemonic words](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki), is superior for human interaction compared to the handling of seed. If you don't plan to custody user's private key, make sure you present the recovery phrase to your user. Currently English and traditional Chinese are supported.

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
import "github.com/bitmark-inc/bitmark-sdk-go/account"

func recoverFromSeedExample() {
    account, err := account.FromSeed("9J87CAsHdFdoEu6N1unZk3sqhVBkVL8Z8")
}
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

// Tranditional Chinese version
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
import "github.com/bitmark-inc/bitmark-sdk-go/account"

func recoverFromPhraseExample() {
    account := account.FromRecoveryPhrase(
        []string{
            "name", "gaze", "apart", "lamp", " lift", " zone",
            "believe" , "steak", "session", "laptop", "crowd", "hill",
        },
        language.AmericanEnglish,
    )
}
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
import "github.com/bitmark-inc/bitmark-sdk-go/account"

func main() {
    valid := account.IsValidAccountNumber(accountNumber)
}
```

The function returns a boolean to indicate whether a given account number is valid in current runtime environment, i.e.,
the format is correct and its network matches to the network specified in the SDK config during initialization.

### Parse information from an account number

```javascript
let accountInfo = Account.parseAccountNumber(accountNumber);
//{
//  network: "livenet",
//  pubKey: "6kJrV6VNhS6juuceTCKMmek1WrXopvbzNTvYqANy"
//}
```

```swift
let (network, pubkey) = try Account.parseAccountNumber(accountNumber)
```

```java
AccountNumberData accountNumberData = Account.parseAccountNumber(accountNumber);
Network network = accountNumberData.getNetwork();
byte[] publicKey = accountNumberData.getPublicKey().toBytes();
```

```go
import "github.com/bitmark-inc/bitmark-sdk-go/account"

func main() {
    network, pubkey, err := account.ParseAccountNumber(accountNumber)
}
```

The function parses an account number and returns its network and public key.
