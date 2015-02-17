require_relative '../parser.rb'


describe Parser do
  
  context 'can parse' do
    nofail = false
    quiet = true
    
    it 'the test file' do
      Parser.parse_file 'parser_test_file', nofail, quiet
    end
    
  end
    
end