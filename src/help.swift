import Foundation

func help(){
  print ("""
Usage: pdef [-v | --version] [-h | --help] [-d <domain> | --domain <domain>] <command>
    
<command> : 
    dump [<name>]
        : Dump plist(property lists) of all domains. You can name dumpped plist. default name is "no-name" if you ommit name. Dumped plist is saved to "/tmp/pdef/<name>/<domain>"
    out [-b <name> | --before <name>] [-a <name> | --after <name>]
        : Output shell scripts to std-out for patching plist. It contain commands "defaults" and "PlistBuddy". The shell script writes Mac OS X user defaults from a diffarence between --before <name> plist and --after <name> plist. Default name is "no-name" if you omit --before option. Output with Dumping all domains by defalut name "no-name-after", if you omit --after option.

<options> :
    [-v | --version]
        : Show version of this software.
    [-h | --help]
        : Show how to use this software.
    [-d <domain> | --domain <domain>]
        : Specify a domain to dump plist or outout shell scripts. You can confirm domains list by a command "defaults domains". All domain's plist is dumped/outout, if you omit the option.

Description:
pdef make a shell script to write Mac OS X user defaults.
"""
  )
}