#!/bin/sh

# Initialize
SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd "$SCRIPT_DIR/.."

domain="net.basd4g.debug"

function dump() {
  filename="$1"
  echo "Info: Dump to file '$filename'"
  defaults export "$domain" - > "$filename"
}

dump 1.xml

sh test/defaults.sh "$domain"
echo "Info: Change plist of '$domain'"

dump 2.xml

echo "Info: Fix changed plist"
./bin/patch-defaults "$domain" 2.xml 1.xml | sh

dump 3.xml

if ! diff 1.xml 3.xml ; then
  echo  "ERROR: 1.xml != 3.xml"
  exit 1
fi

echo 'Info: Change fixed plist'
./bin/patch-defaults "$domain" 1.xml 2.xml | sh

dump 4.xml

if ! diff 2.xml 4.xml ; then
  echo  "ERROR: 2.xml != 4.xml"
  exit 1
fi

rm 1.xml 2.xml 3.xml 4.xml

echo  'Info: Success!'

