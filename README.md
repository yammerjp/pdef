# patch-defaults

patch-defaults is CLI tool to generate shell-script to set property list of macOS.

__This is under developping...__

## Description

Before and after you set any environmental setting from GUI, Please write property list to files.

patch-defaults generate a shell-script with comparing property lists.

Next time you set same enviromental settings, you only excute the shell-script without manipulate GUI.

## Install (Plan)

```sh
$ brew tap basd4g/patch-defaults
$ brew install patch-defaults
```

## Usage (Plan)

```sh
$ defaults read > before

# Set any settings on GUI

$ defaults read > after

$ patch-defaults before after > path/to/file
```

## Generated shell-script example (Plan)

```sh
#!/bin/sh

if ! which defaults > /dev/null ; then
  exit 1
fi

defaults write example.com hoge  -array-add fugafuga
defaults delete -g hogehoge fugafuga
```

## For developper

```sh
# Compile
$ make

# run
$ defaults read > before.plist
$ defaults read > after.plist
$ bin/patch-defaults before.plist after.plist
```

## License

[MIT](https://github.com/basd4g/patch-defaults/blob/master/LICENSE)

## Auther

[basd4g](https://github.com/basd4g)
