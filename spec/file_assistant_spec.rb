require 'helper'

describe FileAssistant do
   context 'when specified file exists' do
      it 'returns an array containing the contents of file' do
         file_assistant = FileAssistant.new
         list = file_assistant.files_to_delete("to_delete")
         # TODO
      end
   end
end
