require 'helper'
require 'fileutils'

# Test configuration helper
module TestConfig
  @backup_file_name = FileAssistantConfig.to_delete + '.bak'
  @temp_test_file_prefix = 'testXyz123'
  @patterns_to_delete = [ "#{@temp_test_file_prefix}*.a", "#{@temp_test_file_prefix}*.obj" ]

  def self.backup_file
    @backup_file_name
  end

  def self.test_prefix
    @temp_test_file_prefix
  end

  def self.patterns
    @patterns_to_delete
  end

end


# Test the FileAssistant class
describe FileAssistant do

  describe '#read_file' do
    context 'when file to read exists' do
      it 'returns an array containing contents of a file' do
        patterns = TestConfig.patterns
        temp_file_name = "#{TestConfig.test_prefix}_patterns.txt"

        # Create test file with contents
        temp_file = File.new( temp_file_name, "w" )
        temp_file.puts patterns
        temp_file.close

        # Test
        assist = FileAssistant.new
        contents = assist.read_file( temp_file_name )
        i = 0
        patterns.each do |line|
          line.should == contents[i]
          i += 1
        end

        File.delete( temp_file_name )
      end
    end
  end

  describe '#read_file' do
    context 'when file to read does not exist' do
      it 'returns nil' do
        temp_file_name = "#{TestConfig.test_prefix}_dne.txt"
        assist = FileAssistant.new
        contents = assist.read_file( temp_file_name )
        contents.should == nil
      end
    end
  end

  describe '#read_file' do
    it 'displays matching files based on patterns in a file' do
      # Setup
      patterns = [ '**/*.rb', '**/*.html' ]
      temp_file_name = "#{TestConfig.test_prefix}_patterns.txt"
      temp_file = File.new( temp_file_name, "w" )
      temp_file.puts patterns
      temp_file.close

      # Test
      assist = FileAssistant.new
      contents = assist.read_file( temp_file_name )
      contents.should_not == nil
      puts "======= Test match patterns from input file ======="
      puts ">>> Patterns to match:"
      puts contents
      puts ">>> Matches:"
      contents.each do |pattern|
        matches = Dir.glob( "#{pattern}" )
        matches.each { |match| puts match }
      end
      puts "======= End match patterns from input file ======="

      File.delete( temp_file_name )
    end
  end

  describe '#get_matching_files' do
    it 'gets a list of patterns then find list of matching files' do
      # Setup
      patterns_to_delete = TestConfig.patterns
      files_that_match = [ "#{TestConfig.test_prefix}a.a",
                           "#{TestConfig.test_prefix}r.obj",
                           "#{TestConfig.test_prefix}z.obj" ]
      # Create file containing patterns
      patterns_to_delete_file = "#{TestConfig.test_prefix}_patterns.txt"
      pattern_file = File.new( patterns_to_delete_file, "w" )
      pattern_file.puts patterns_to_delete
      pattern_file.close
      # Create the test files
      files_that_match.each do |file|
        temp_file = File.new( file, "w" )
        temp_file.close
      end

      # Read patterns
      assist = FileAssistant.new
      patterns = assist.read_file( patterns_to_delete_file )
      # Get matching files
      matches = assist.get_matching_files( patterns )
      i = 0
      files_that_match.each do |file|
        file.should == matches[i]
        i += 1
      end

      # Delete the test files
      File.delete( patterns_to_delete_file )
      files_that_match.each { |file| File.delete( file ) }
    end
  end

  describe '#delete_files' do
    it 'deletes a file matching patterns in an array' do
      test_dir_name = "#{TestConfig.test_prefix}_dir"
      test_dir_to_delete_name = "#{TestConfig.test_prefix}_delete_dir"
      test_dir_to_keep_name = "#{TestConfig.test_prefix}_keep_dir"
      keep_file_names = [ "#{TestConfig.test_prefix}a.obj",
                          "#{TestConfig.test_prefix}_another.obj",
                          "#{TestConfig.test_prefix}abc.obj",
                          "#{TestConfig.test_prefix}2.a" ]
      delete_file_names = [ "#{TestConfig.test_prefix}aa.a",
                            "#{TestConfig.test_prefix}bb.a",
                            "#{TestConfig.test_prefix}zz.a" ]
      patterns = [ "**/#{test_dir_to_delete_name}/**/#{TestConfig.test_prefix}*.obj",
                   "**/#{test_dir_to_delete_name}/**/#{TestConfig.test_prefix}*.a" ]

      # Create the test files and confirm; Create test directory two levels deep
      FileUtils.mkdir_p "#{test_dir_name}/#{test_dir_to_delete_name}"
      FileUtils.mkdir_p "#{test_dir_name}/#{test_dir_to_keep_name}"
      # Create files to keep
      FileUtils.cd "#{test_dir_name}/#{test_dir_to_keep_name}"
      keep_file_names.each do |file|
        test_file = File.new( file, "w" )
        test_file.puts 'Hi there'
        test_file.close
      end
      # Create files to delete
      FileUtils.cd "../#{test_dir_to_delete_name}"
      delete_file_names.each do |file|
        test_file = File.new( file, "w" )
        test_file.puts 'Hi there'
        test_file.close
      end
      FileUtils.cd "../.."

      # Get matching files then delete the files
      assist = FileAssistant.new
      files = assist.get_matching_files( patterns )
      assist.delete_files( files )

      # Confirm files kept
      FileUtils.cd "#{test_dir_name}/#{test_dir_to_keep_name}"
      keep_file_names.each { |file| File.exists?(file).should == true }
      # Confirm deleted
      FileUtils.cd "../#{test_dir_to_delete_name}"
      delete_file_names.each { |file| File.exists?(file).should_not == true }
      # Remove the test files and directories
      FileUtils.cd "../.."
      FileUtils.rm_rf "#{test_dir_name}"  # remove test directories
    end
  end

end

