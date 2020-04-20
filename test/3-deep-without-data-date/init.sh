#!/bin/sh -e

domain="$1"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd "$SCRIPT_DIR"

defaults import "$domain" plist-before.xml

