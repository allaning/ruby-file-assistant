require 'helper'

@@backup_of_to_delete = 'backup_of_to_delete'

describe FileAssistant do

  context 'when config file does not exist' do
    it 'does nothing' do
      # Rename existing file
      if File.exists?( FileAssistantConfig.to_delete )
        File.rename(FileAssistantConfig.to_delete, @@backup_of_to_delete)
      end

      file_assistant = FileAssistant.new
      list = file_assistant.files_to_delete
      list.should == nil

      # Restore original config file
      if File.exists?( @@backup_of_to_delete )
        File.rename(@@backup_of_to_delete, FileAssistantConfig.to_delete)
      end
    end
  end

  context 'when config file exists' do
    it 'returns an array containing the contents of file' do
      # Contents of test file
      contents = ["a", "b", "c"]

      # Rename existing file, then create a new test input file
      if File.exists?( FileAssistantConfig.to_delete )
        File.rename(FileAssistantConfig.to_delete, @@backup_of_to_delete)
      end
      new_file = File.new( FileAssistantConfig.to_delete, "w" )
      contents.each { |line| new_file.puts line }
      new_file.close

      file_assistant = FileAssistant.new
      list = file_assistant.files_to_delete
      # TODO
      list.each {|x| puts x}
      list.size.should == 3
      #list.each { |item| expect( contents.include?(item) ).to eq(true) }

      File.delete( FileAssistantConfig.to_delete )

      # Restore original config file
      if File.exists?( @@backup_of_to_delete )
        File.rename(@@backup_of_to_delete, FileAssistantConfig.to_delete)
      end
    end
  end

end
