require 'file_assistant_config'

class FileAssistant

  # If the config file containing list of patterns to delete exists,
  # open the file and return its contents as an array
  def files_to_delete
    if File.exists?( FileAssistantConfig.to_delete )
      config_file = File.open( FileAssistantConfig.to_delete, "r")
      contents = []
      config_file.each { |line| contents << line.chomp }
      config_file.close
      return contents
    end
  end

end
