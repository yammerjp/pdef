#!/bin/sh -e

domain="$1"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd "$SCRIPT_DIR"

defaults delete "$domain" > /dev/null 2>&1
defaults import "$domain" 2.plist

