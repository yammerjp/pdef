#!/bin/sh -e

domain="$1"

defaults write net.basd4g.debug "defaults.sh-7-array" -array-add "0800"
defaults write net.basd4g.debug "defaults.sh-8-dict" -dict-add "key5" "string"
