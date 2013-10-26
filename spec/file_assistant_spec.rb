require 'helper'

# Test configuration helper
module TestConfig
  @backup_file_name = FileAssistantConfig.to_delete + '.bak'
  @temp_test_file_prefix = 'testXyz123_'

  def self.backup_file
    @backup_file_name
  end

  def self.test_prefix
    @temp_test_file_prefix
  end
end


# Test the FileAssistant class
describe FileAssistant do

  context 'when file to read exists' do
    it 'returns an array containing contents of a file' do
      patterns = [ '*.a', '*.obj' ]
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

  context 'when file to read does not exist' do
    it 'returns nil' do
      temp_file_name = "#{TestConfig.test_prefix}_dne.txt"
      assist = FileAssistant.new
      contents = assist.read_file( temp_file_name )
      contents.should == nil
    end
  end

  context 'when to_delete config file does not exist' do
    it 'does nothing' do
      # Rename existing file
      if File.exists?( FileAssistantConfig.to_delete )
        File.rename(FileAssistantConfig.to_delete, TestConfig.backup_file)
      end

      file_assistant = FileAssistant.new
      list = file_assistant.files_to_delete
      list.should == nil

      # Restore original config file
      if File.exists?( TestConfig.backup_file )
        File.rename(TestConfig.backup_file, FileAssistantConfig.to_delete)
      end
    end
  end

  context 'when to_delete config file exists' do
    it 'returns an array containing the contents of file' do
      # Contents of test file
      contents = ["a", "b", "c"]

      # Rename existing file, then create a new test input file
      if File.exists?( FileAssistantConfig.to_delete )
        File.rename(FileAssistantConfig.to_delete, TestConfig.backup_file)
      end
      new_file = File.new( FileAssistantConfig.to_delete, "w" )
      contents.each { |line| new_file.puts line }
      new_file.close

      file_assistant = FileAssistant.new
      list = file_assistant.files_to_delete
      # Verify contents with golden file
      index = 0
      list.each do |item|
        item.should == contents[index]
        index += 1
      end

      # Restore original config file
      File.delete( FileAssistantConfig.to_delete )
      if File.exists?( TestConfig.backup_file )
        File.rename(TestConfig.backup_file, FileAssistantConfig.to_delete)
      end
    end
  end

  it 'deletes a file matching patterns in an array' do
    file_names = [ "#{TestConfig.test_prefix}a.obj",
                   "#{TestConfig.test_prefix}_another.obj",
                   "#{TestConfig.test_prefix}abc.obj",
                   "#{TestConfig.test_prefix}2.a" ]
    patterns = [ "**/#{TestConfig.test_prefix}*.obj",
                 "**/#{TestConfig.test_prefix}*.a" ]

    # Create the test files and confirm
    file_names.each do |file|
      test_file = File.new( file, "w" )
      test_file.puts 'Hi there'
      test_file.close
    end
    file_names.each do |file|
      File.exists?(file).should == true
    end

    # Delete the files
    assist = FileAssistant.new
    assist.delete_files( patterns )

    # Confirm deleted
    file_names.each do |file|
      File.exists?(file).should_not == true
    end
  end

end
