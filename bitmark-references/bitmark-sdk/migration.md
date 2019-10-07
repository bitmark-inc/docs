# Account migration

Bitmark SDK provides `rekey` method to allow users to transfer all bitmarks from an `Account` to another one. This is helpful in case users want to migrate all their own bitmarks from old `Account` to another new one and keep the bitmarks provenance as well.

The method takes different `Account` as source and destination one and return the collection of new transaction id when complete.

```javascript
// Not supported at the moment. If you have demand for this function, please feel free to contact us.
```

```swift
let phrase = ["abuse", "tooth", "riot", "whale", "dance", "dawn", "armor", "patch", "tube", "sugar", "edit", "clean",
                "guilt", "person", "lake", "height", "tilt", "wall", "prosper", "episode", "produce", "spy", "artist", "account"]
let (account, bitmarkids) = try Migration.migrate(recoverPhrase: phrase, language: .english)
```

```java
Account source = new Account();
Account destination = new Account();
Migration.rekey(
                source,
                destination,
                new Callback1<List<String>>() {
                    @Override
                    public void onSuccess(List<String> txIds) {
                        // collection of new tx id is returned here
                    }

                    @Override
                    public void onError(Throwable e) {
                        // handle error here
                    }
                }
        );
```
