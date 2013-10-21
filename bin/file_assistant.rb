require 'file_assistant_config'

class FileAssistant

  def files_to_delete
    if File.exists?( FileAssistantConfig.to_delete )
      config_file = File.open( FileAssistantConfig.to_delete, "r")
      contents = []
      config_file.each { |line| contents << line }
      config_file.close
      return contents
    end
  end
end
