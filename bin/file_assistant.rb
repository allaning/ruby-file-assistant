require 'file_assistant_config'

# Ruby File Assistant (RFA) helps automate mundane file management tasks.
# Create configuration files to instruct RFA to perform tasks such as
# deleting or renaming files based on specified patterns.
class FileAssistant

  # Reads and returns contents of specified file.
  def read_file( file_name )
    if File.exists?( file_name )
      file = File.open( file_name, "r" )
      contents = []
      file.each { |line| contents << line.chomp }
      file.close
      return contents
    end
  end

  # If the config file containing list of patterns to delete exists,
  # open the file and return its contents as an array.
  def get_files_to_delete
    read_file( FileAssistantConfig.to_delete )
  end

  # Delete files matching specified patterns.
  # Patterns must be specified in an array.
  def delete_files( patterns )
    patterns.each do |pattern|
      found_files = Dir.glob( "#{pattern}" )
      found_files.each do |found_file|
        puts "Deleting file: #{found_file}"
        File.delete( found_file )
      end
    end
  end

end
