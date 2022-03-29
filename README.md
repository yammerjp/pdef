[![CI](https://github.com/yammerjp/pdef/workflows/CI/badge.svg)](https://github.com/yammerjp/pdef/actions)
# pdef

pdef generates patch script of Mac OS X User Defaults (property list).

## Description

Before and after you set any environmental settings from GUI, please write out property lists to files.

pdef generates a shell-script with comparing files of a property list.

Next time you set the same environmental settings, you only execute the shell-script without manipulating GUI.

## Install

```sh
$ brew install yammerjp/tap/pdef
```

## Usage

```sh
$ defaults read > before

# Set any settings on GUI

$ defaults read > after

$ pdef before after > path/to/file
```

## Demo

![demo movie](demo.gif)

## Build

```sh
$ git clone https://github.com/yammerjp/pdef.git
$ cd pdef
$ make
# built binary is on bin/pdef
```

## License

[MIT](https://github.com/basd4g/pdef/blob/master/LICENSE)

## Auther

[yammerjp](https://github.com/yammerjp)

