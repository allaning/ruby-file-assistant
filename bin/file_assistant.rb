require_relative 'file_assistant_config'

# Ruby File Assistant (RFA) helps automate mundane file management tasks.
# Create configuration files to instruct RFA to perform tasks such as
# deleting or renaming files based on specified patterns.
class FileAssistant
  def initialize
  end

  # Show list of matches to_delete and prompt user to delete them.
  def prompt_for_files_to_delete
    patterns = get_patterns_to_delete
    if patterns != nil
      puts 'Patterns to delete:'
      puts '==================='
      puts patterns
      puts 'Matching Files to be deleted:'
      puts '============================='
      found_files = get_matching_files( patterns )
      if found_files.length > 0
        puts found_files
        puts '============================='
        # Prompt user
        print 'Delete (y/N)? '
        answer = gets.chomp
        if answer.upcase == 'Y'
          puts "Deleting files..."
          delete_files( patterns )
        else
          puts 'Aborted.'
        end
      else
        puts 'No matching files found.'
      end
    else
      puts 'No to_delete input file found.'
    end
  end

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
  def get_patterns_to_delete
    read_file( FileAssistantConfig.to_delete )
  end

  # Returns list of file names that match specified pattern
  def get_matching_files( patterns )
    results = []
    patterns.each do |pattern|
      found_files = Dir.glob( "#{pattern}" )
      found_files.each { |match| results << match }
    end
    return results
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

end  # class FileAssistant


# Script starts here
file_assistant = FileAssistant.new
if ARGV[0] == "-f"
  # Delete files without prompting
  patterns = file_assistant.get_patterns_to_delete
  puts 'Patterns to delete:'
  puts '==================='
  puts patterns
  puts '==================='
  file_assistant.delete_files( patterns )
else
  ARGV.clear
  file_assistant.prompt_for_files_to_delete
end

