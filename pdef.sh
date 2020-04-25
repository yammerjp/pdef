#!/bin/sh
pdefdir="/tmp/patch-defaults"

domains() {
  defaults domains |  sed 's/, /,/' | tr ',' '\n'
}

dump() {
  dumpdir="$1"

  rm -rf "$dumpdir"
  mkdir -p "$dumpdir"

  domains | while read -r domain
  do
    defaults export "$domain" "$dumpdir/$domain"
  done
}

getdumpname() {
  inputname="$1"
  defaultname="$2"
  if [ "$inputname" = "" ] || [ "$inputname" = "-" ]; then
    inputname="$defaultname"
  fi
  echo "$inputname"
}

# ./pdef.sh dump (name)
if [ "$1" = "dump" ]; then
  dumpname="$(getdumpname "$2" "no-name")"
  dump "$pdefdir/$dumpname"
  exit 0
# ./pdef.sh help
elif ! [ "$1" = "out" ]; then
  echo "help message"
  exit 0
fi

# ./pdef.sh out (name before) (name after)
before="$(getdumpname "$2" "no-name")"
if ! ls "$pdefdir/$before" > /dev/null ; then
  echo "Error. before dump files is not found"
fi

after="$(getdumpname "$3" "no-name-after")"
if ! ls "$pdefdir/$after" > /dev/null ; then
  dump "$pdefdir/$after"
fi

domains | while read -r domain
do
  ./bin/patch-defaults "$domain" "$pdefdir/$before/$domain" "$pdefdir/$after/$domain"
done

