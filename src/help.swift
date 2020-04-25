let HelpMessage = DescriptionMessage + UsageMessage + HelpMessageTail

let UsageMessage = """
Usage: patch-defaults [-v | --version] [-h | --help] [-d <domain> | --domain <domain>] <file1> <files2>

"""

let DescriptionMessage = """
patch-defaults writes out a shell-script to stdout for changing Mac OS X User Defaults (property list) from <file1> to <file2>.
( <file1> and <file2> is property list (plist) that dumped by the command 'defaults read')


"""

let HelpMessageTail =
"""

<options> :
    [-v | --version] :
        Show version of this software.
    [-h | --help] :
        Show how to use this software.
    [-d <domain> | --domain <domain>] :
        Specify a domain of <file1> and <file2>. With this option. <file1> and <file2> must be a plsit of designated domain.
        You can confirm domains list by a command "defaults domains".
        Omit the option for compare all domain's plist.

Examples:
    all domains :
        $ defaults read > before.plist
        # Chenge some settings with GUI
        $ defaults read > after.plist
        $ patch-defaults before.plist after.plist
    specified domain :
        $ defaults export "com.apple.systemuiserver" - > before.plist
        # Chenge some settings of systemuiserver with GUI 
        $ defaults export "com.apple.systemuiserver" - > before.plist
        $ patch-defaults --domain "com.apple.systemuiserver" before.plist after.plist

"""
