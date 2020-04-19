#!/bin/sh -e

domain="$1"

defaults delete "$domain" > /dev/null 2>&1

defaults write net.basd4g.debug "defaults.sh-0-ascii" -string "helloworld"
defaults write net.basd4g.debug "defaults.sh-1-emoji" -string "😀😁😂"
defaults write net.basd4g.debug "defaults.sh-2-data" -data 0123456789abcdef
defaults write net.basd4g.debug "defaults.sh-3-integer" -integer 123
defaults write net.basd4g.debug "defaults.sh-4-data" -float 0.5
defaults write net.basd4g.debug "defaults.sh-5-bool" -bool true
defaults write net.basd4g.debug "defaults.sh-6-date" -date 2019-09-16T05:45:42Z
defaults write net.basd4g.debug "defaults.sh-7-array" -array "str" "str" "0" "1" "5.3" "addstring"
defaults write net.basd4g.debug "defaults.sh-8-dict" -dict "key0" "value" "key1" "0" "key2" "2019-09-16 05:45:42 +0000" "key3" "true" "key4" "string"
defaults write net.basd4g.debug "setup-0" -string "helloworld"
defaults write net.basd4g.debug "setup-1" -integer 123
defaults write net.basd4g.debug "setup-2" -float 0.5
defaults write net.basd4g.debug "setup-3" -bool true
