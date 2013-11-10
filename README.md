Ruby File Assistant

Ruby File Assistant (RFA) helps automate mundane file management tasks.  Create configuration files to instruct RFA to perform tasks such as deleting files based on specified regular expression patterns.  This could be useful to clean generated files, such as object code during development--especially if there are multiple target directories involved.

Currently, RFA has the ability to delete files specified by regular expressions listed in a file.  The default file name that the tool will search for is to_delete.  Optionally, an alternate file can be specified after the -d command line switch.  See the to_delete file in this repository for some examples.

To tell Ruby File Assistant to delete files in the to_delete file, enter the following command:

ruby bin/file-assistant.rb -d

Ruby File Assistant will read the to_delete file and any files matching the specified patterns will be displayed.  The user will then be prompted to confirm deletion of the files before the files are removed.

Users may force deletion without being prompted by providing the -f switch as such:

ruby bin/file-assistant.rb -d -f

In either case, a list of files will be displayed as they are deleted.

The following usage summary can be seen by entering: ruby bin/file_assistant.rb -h

Usage: file_assistant [options]
    -d [FILE_WITH_PATTERNS],         Delete files with names matching patterns listed in
        --delete                     FILE_WITH_PATTERNS file.  Default file name is to_delete.
    -f, --force                      Force actions without confirming
    -h, --help                       Show this message

