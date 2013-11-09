require_relative 'file_assistant_config'
require 'optparse'

# Ruby File Assistant (RFA) helps automate mundane file management tasks.
# Create configuration files to instruct RFA to perform tasks such as
# deleting or renaming files based on specified patterns.
class FileAssistant
  attr_accessor :files_to_delete

  def initialize
    self.files_to_delete = FileAssistantConfig.to_delete
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
  def delete_files( files )
    files.each do |file|
      puts "Deleting file: #{file}"
      File.delete( file )
    end
  end

end  # class FileAssistant

# Parse command line args
def parse_args(argv = ::ARGV)
  params = {}
  opt_parser = OptionParser.new do |opt|
    opt.on("-d", "--delete", "Delete files") { params[:delete] = true }
    opt.on("-f", "--force", "Force without confirming") { params[:force] = true }
    opt.on_tail("-h", "--help", "Show this message") do
      puts opt
      exit
    end
  end
  opt_parser.parse! argv
  params
end


# Script starts here
file_assistant = FileAssistant.new
params = parse_args
#puts params

if params[:delete] == true
  # Get list of files to delete
  patterns = file_assistant.read_file( file_assistant.files_to_delete )
  puts 'Patterns to delete:'
  puts '==================='
  puts patterns
  puts '==================='
  files = file_assistant.get_matching_files( patterns )
  if files.length > 0
    puts files
    unless params[:force] == true
      # Prompt user to confirm deletion
      print 'Delete (y/N)? '
      ARGV.clear
      answer = gets.chomp
      unless answer.upcase == 'Y' || answer.upcase == "YES"
        puts 'Aborted.'
        exit
      end
    end
    file_assistant.delete_files( files )
  else
    puts 'No matching files found.'
  end
end

