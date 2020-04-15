# patch-defaults

patch-defaults is CLI tool to generate shell-script to set property list of macOS.

This is under developping...

## How to use

```sh
$ patch-defaults read before

# Set any settings on GUI

$ patch-defalts read after
$ patch-defaults make --full > path/to/file

```

## Generated shell-script example

```sh
#!/bin/sh

if ! which defaults > /dev/null ; then
  exit 1
fi

defaults write example.com hoge  -array-add fugafuga
defaults delete -g hogehoge fugafuga

```

