# How to run spelling check?

`$ sh check-spelling.sh ${doc}`

# How to add words to Bitmark dictionary?

`en_Bitmark.dic` contains a list of words, one per line. The first line of the dictionaries contains the approximate word count (for optimal hash memory size). Each word may optionally be followed by a slash ("/") and one or more flags, which represents the word attributes, such as prefixes and suffixes. The supported flags are:

| Flag | Meaning         | Example | Acceptable spellings |
|------|-----------------|---------|----------------------|
| D    | past tense form | word/D  | work, worked         |
| S    | plural form     | apple/S | apple, apples        |
| O    | possessive      | Alice/O | Alice, Alice's       |

After new words are added, sort the dictionary file and update the word count.

```shell
$ tail -n +2 en_BITMARK.dic | sort -f -o en_BITMARK.dic
$ printf '%s\n' 0a $(wc -l <en_BITMARK.dic) . x | ex en_BITMARK.dic
```