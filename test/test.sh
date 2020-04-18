#!/bin/sh

# Initialize

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR
cd ..
domain="net.basd4g.debug"

function dump() {
  filename=$1
  echo "info: dump to file '$filename'"
  defaults export "$domain" - > "$filename"
}

dump 1.xml

echo "info: change plist of '$domain'"
sh test/defaults.sh "$domain"

dump 2.xml

echo "info: fix changed plist"
./bin/patch-defaults "$domain" 2.xml 1.xml | sh

dump 3.xml

if ! diff 1.xml 3.xml ; then
  echo  'error: 1.xml != 3.xml'
  exit(1)
fi

echo 'info: change fixed plist'
./bin/patch-defaults "$domain" 1.xml 2.xml | sh

dump 4.xml

if ! diff 2.xml 4.xml ; then
  echo  'error: 2.xml != 4.xml'
  exit(1)
fi

rm 1.xml 2.xml 3.xml 4.xml

echo  'info: success!'

