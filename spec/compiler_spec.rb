require_relative '../compiler.rb'



nofail = false

describe Compiler do
  
  context 'can compile' do
    quiet = false
    
    it 'addition' do
      Compiler.compile_file './spec/test_data/compiler/addition', nofail, quiet
    end
    
    it 'concatenation' do
      Compiler.compile_file './spec/test_data/compiler/concat', nofail, quiet
    end
    
    it 'negation' do
      Compiler.compile_file './spec/test_data/compiler/negate', nofail, quiet
    end

    it 'subtraction' do
      Compiler.compile_file './spec/test_data/compiler/subtraction', nofail, quiet
    end
    
    it 'complex files' do
      Compiler.compile_file './spec/test_data/compiler/swag', nofail, quiet
    end
    
    it 'More complex files' do
      Compiler.compile_file './spec/test_data/compiler/testo', nofail, quiet
    end
    
    it 'strings' do
      Compiler.compile_file './spec/test_data/compiler/strings', nofail, quiet
    end
    
    
  end
  
  context 'can NOT compile' do
    
    quiet = true
    
    
    it 'concatenation between strings and other things' do
      expect{Compiler.compile_file './spec/test_data/compiler/undefined_concatenation', nofail, quiet}.to raise_error
    end
    
    it 'trig with non reals' do
      expect{Compiler.compile_file './spec/test_data/compiler/invalid_trig', nofail, quiet}.to raise_error
    end
    
    
    
    it 'unclosed parenthesis' do
      expect{Compiler.compile_file('./spec/test_data/unclosed_parens', nofail, quiet)}.to raise_error
    end
    
    it 'unopened parenthesis' do
      expect{Compiler.compile_file('./spec/test_data/unopened_parens', nofail, quiet)}.to raise_error
    end
    
    it 'lonely varlist' do
      expect{Compiler.compile_file('./spec/test_data/varlist', nofail, quiet)}.to raise_error
    end
    
    it 'lonely operators' do
      expect{Compiler.compile_file('./spec/test_data/plus', nofail, quiet)}.to raise_error
    end
    
    it 'lonely expressions' do
      expect{Compiler.compile_file('./spec/test_data/lonely_addition', nofail, quiet)}.to raise_error
    end
    
    it 'unfinished transitions' do
      expect{Compiler.compile_file('./spec/test_data/unfinished_transition', nofail, quiet)}.to raise_error
    end
    
    it 'an empty file' do
      expect{Compiler.compile_file('./spec/test_data/empty', nofail, quiet)}.to raise_error
    end
    
    it 'negatives how normal people would write them' do
      expect{Compiler.compile_file('./spec/test_data/negative', nofail, quiet)}.to raise_error
    end
    
    
  end
    
end