#!/bin/sh

domain="$1"

defaults write "$domain" defaults.sh-0-ascii   -string    helloworld
defaults write "$domain" defaults.sh-1-emoji   -string    "😀😁😂"
defaults write "$domain" defaults.sh-2-data    -data      0123456789abcdef
defaults write "$domain" defaults.sh-3-integer -integer   123
defaults write "$domain" defaults.sh-4-data    -float     0.5
defaults write "$domain" defaults.sh-5-bool    -bool      true
defaults write "$domain" defaults.sh-6-date    -date      "2019-09-16 05:45:42 +0000"
defaults write "$domain" defaults.sh-7-array   -array     str "str" 0 1 5.3
defaults write "$domain" defaults.sh-7-array   -array-add addstring
defaults write "$domain" defaults.sh-8-dict    -dict      key0 value key1 0 key2 "2019-09-16 05:45:42 +0000" key3 true
defaults write "$domain" defaults.sh-8-dict    -dict-add  key4 string

