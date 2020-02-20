#!/bin/sh
# spelling check for markdown files
dict='en_US,en_GB,en_BITMARK'
printf -- 'file: %s\n' "${1}"
awk '
    BEGIN {
        code=0
        flag=1
    }
    /^~~~|^[[:space:]]*```/{
        code = !code
        flag=0
    } 
    {
        if(!code && flag) {
            gsub("`[^`]+`","")
            gsub("][(][^)]*[)]","]")
            print $0
        }
        flag=1
    }' "${1}" \
 | hunspell -d "${dict}" -i UTF-8 -l \
 | sort -u \
 | awk 'BEGIN {count=0} {count++; print $0} END {if (count > 0) {print "errors: " count "\n"; exit 1}}'
