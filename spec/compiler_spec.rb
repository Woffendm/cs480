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
    
    it 'conditionals' do
      Compiler.compile_file './spec/test_data/compiler/conditionals', nofail, quiet
    end
    
    it 'loops' do
      Compiler.compile_file './spec/test_data/compiler/loops', nofail, quiet
    end
    
    it 'multiple_variable_arithmatic' do
      Compiler.compile_file './spec/test_data/compiler/multiple_variable_arithmatic', nofail, quiet
    end
    
    it 'single_variable_arithmatic_and_scope' do
      Compiler.compile_file './spec/test_data/compiler/single_variable_arithmatic_and_scope', nofail, quiet
    end
    
    it 'print' do
      Compiler.compile_file './spec/test_data/compiler/print', nofail, quiet
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
    
    it 'undeclared variables' do
      expect{Compiler.compile_file('./spec/test_data/compiler/undeclared_variable', nofail, quiet)}.to raise_error
    end
    
    it 'unassigned variables' do
      expect{Compiler.compile_file('./spec/test_data/compiler/unassigned_variable', nofail, quiet)}.to raise_error
    end
    
    it 'variable type errors' do
      expect{Compiler.compile_file('./spec/test_data/compiler/variable_type_error', nofail, quiet)}.to raise_error
    end
    
    
  end
    
end