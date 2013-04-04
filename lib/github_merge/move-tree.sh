#!/bin/sh

git filter-branch --index-filter \
        'git ls-files -s | gsed "s@\t@&'"$1"'/@" |
                GIT_INDEX_FILE=$GIT_INDEX_FILE.new \
                        git update-index --index-info &&
         mv "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE"'
