require_relative '../parser.rb'



nofail = false

describe Parser do
  
  context 'can parse' do
    quiet = false
    
    it 'the test file' do
      Parser.parse_file './spec/test_data/parser_test_file', nofail, quiet
    end
    
    it 'proftest1' do
      Parser.parse_file './spec/test_data/proftest1.in', nofail, quiet
    end
    
    it 'proftest2' do
      Parser.parse_file './spec/test_data/proftest2.in', nofail, quiet
    end

    it 'proftest3' do
      Parser.parse_file './spec/test_data/proftest3.in', nofail, quiet
    end
    
  end
  
  
  context 'can NOT parse' do
    quiet = true
    it 'unclosed parenthesis' do
      expect{Parser.parse_file('./spec/test_data/unclosed_parens', nofail, quiet)}.to raise_error
    end
    
    it 'unopened parenthesis' do
      expect{Parser.parse_file('./spec/test_data/unopened_parens', nofail, quiet)}.to raise_error
    end
    
    it 'lonely varlist' do
      expect{Parser.parse_file('./spec/test_data/varlist', nofail, quiet)}.to raise_error
    end
    
    it 'lonely operators' do
      expect{Parser.parse_file('./spec/test_data/plus', nofail, quiet)}.to raise_error
    end
    
    it 'lonely expressions' do
      expect{Parser.parse_file('./spec/test_data/lonely_addition', nofail, quiet)}.to raise_error
    end
    
    it 'unfinished transitions' do
      expect{Parser.parse_file('./spec/test_data/unfinished_transition', nofail, quiet)}.to raise_error
    end
    
    it 'an empty file' do
      expect{Parser.parse_file('./spec/test_data/empty', nofail, quiet)}.to raise_error
    end
    
    it 'negatives how normal people would write them' do
      expect{Parser.parse_file('./spec/test_data/negative', nofail, quiet)}.to raise_error
    end
    
    
  end
    
end