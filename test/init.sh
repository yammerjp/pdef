#!/bin/sh

domain="$1"

defaults delete "$domain" > /dev/null 2>&1

defaults write "$domain" setup-0 -string  helloworld
defaults write "$domain" setup-1 -integer 123
defaults write "$domain" setup-2 -float   0.5
defaults write "$domain" setup-3 -bool    true

