# Account migration

Bitmark allows users migrate their own account from previous twenty four recovery phrase words to new twelve one. 

The method requires a valid 24 recovery phrase words and return new `Account` object with 12 recovery phrase words as well as a new list bitmark id. 

```javascript
```

```swift
let phrase = ["abuse", "tooth", "riot", "whale", "dance", "dawn", "armor", "patch", "tube", "sugar", "edit", "clean",
                "guilt", "person", "lake", "height", "tilt", "wall", "prosper", "episode", "produce", "spy", "artist", "account"]
let (account, bitmarkids) = try Migration.migrate(recoverPhrase: phrase, language: .english)
```

```java
final String[] phrase = new String[] {"abuse", "tooth", "riot", "whale", "dance", "dawn", "armor", "patch", "tube", "sugar", "edit", "clean","guilt", "person", "lake", "height", "tilt", "wall", "prosper", "episode", "produce", "spy", "artist", "account"};

Migration.migrate(phrase, new Callback1<Pair<Account, List<String>>>() {
                @Override
                public void onSuccess(Pair<Account, List<String>> data){
                    final Account account = data.first();
                    final List<String> bitmarkids = data.second();
                }

                @Override
                public void onError(Throwable throwable) {
                	// Throwable goes here
                }
            });
```

```go
```