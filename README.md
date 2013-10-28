Ruby File Assistant

Ruby File Assistant (RFA) helps automate mundane file management tasks.  Create configuration files to instruct RFA to perform tasks such as deleting or renaming files based on specified patterns.  This could be useful to clean generated files, such as object code during development--especially if there are multiple target directories involved.

Currently has the ability to delete files specified by patterns kept in a file.  The file must be named to_delete and must be located in the directory from which the tool is run.

To execute, enter the following command:

ruby bin/file-assistant.rb

Ruby File Assistant will read the to_delete file and any files matching the specified patterns will be displayed.  The user will then be prompted to confirm deletion of the files before the files are removed.

Users may force deletion without being prompted by providing the -f switch as such:

ruby bin/file-assistant.rb -f

In either case, a list of deleted files will be displayed.

