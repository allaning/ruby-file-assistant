require 'helper'

# Test configuration helper
module TestConfig
  @backup_file_name = FileAssistantConfig.to_delete + '.bak'

  def self.backup_file
    @backup_file_name
  end
end


# Test the FileAssistant class
describe FileAssistant do

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
    file_names = ['test.obj', 'test_another.obj']
    patterns = ['**/test*.obj']

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
