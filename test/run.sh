#!/bin/sh -e

# Initialize
SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd "$SCRIPT_DIR/.."

domain="net.basd4g.debug"
test_name="$1"

function dump() {
  filename="$1"
  echo "Info: Dump to file '$filename'"
  defaults export "$domain" - > "$filename"
}

echo "Info: Run test '$test_name'"

echo "Info: Initialize plist of '$domain'"
defaults delete "$domain" > /dev/null 2>&1 && :
sh "test/$test_name/init.sh" "$domain"

dump 1.xml

echo "Info: Change plist of '$domain'"
sh "test/$test_name/defaults.sh" "$domain"

dump 2.xml

echo "Info: Fix changed plist"
./bin/patch-defaults --domain "$domain" 2.xml 1.xml | sh

dump 3.xml

if ! diff 1.xml 3.xml ; then
  echo  "ERROR: 1.xml != 3.xml"
  exit 1
fi

echo 'Info: Change fixed plist'
./bin/patch-defaults --domain "$domain" 1.xml 2.xml | sh

dump 4.xml

if ! diff 2.xml 4.xml ; then
  echo  "ERROR: 2.xml != 4.xml"
  exit 1
fi

if [ "$DEBUG" != "1" ] ; then
  rm 1.xml 2.xml 3.xml 4.xml
fi

echo  'Info: Success!'

