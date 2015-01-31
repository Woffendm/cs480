require_relative '../parser2'

nofail = true
quiet = true

describe Parser do
  
  context 'can keep parsing if:' do        
    it 'all invalid' do
      data = "~!?"
      expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
      to eq("")
    end
  end
  
  

  it 'can parse valid stuff in our teaching language' do
    data = "( x int)\n(:= x 9)"
    expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
    to eq("( x int ) ( := x 9 )")
  end
  
  
  it 'can make ids out of partial keywords' do
    data = "strin stdou"
    expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
    to eq("strin stdou")
    
  end
  

  it 'can parse really difficult things correctly' do
    data = "if+string/stdout**notandbool<=:=and"
    expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
    to eq("if + string / stdout * * not and bool <= := and")
  end

  
  context 'can parse:' do
  
    context 'Strings:' do
      it 'just one' do
        data = '"abc 123 %<="'
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq('"abc 123 %<="')
      end
      
      it 'multiple' do
        data = '"abc""doe ray me" "123"'
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq('"abc" "doe ray me" "123"')
      end      
    end
    
    
    
    context 'Integers:' do
      it 'just one' do
        data = '12345'
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq('12345')
      end
      
      it 'multiple' do
        data = '1 23 45'
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq('1 23 45')
      end 
      
      it 'tokenizes on keywords' do
        data = '1+23-45sin67'
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq('1 + 23 - 45 sin 67')
      end      
    end
    
  
  
    context 'Reals:' do
      it 'just one' do
        data = '12.345'
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq('12.345')
      end
      
      it 'multiple' do
        data = '1.23 4.5'
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq('1.23 4.5')
      end 
      
      it 'tokenizes on keywords' do
        data = '1.23+4.5sin67.8'
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq('1.23 + 4.5 sin 67.8')
      end    
      
      it 'behaves properly when presented with multiple periods' do
        data = '1.23.4.5.67.8'
        expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
        to eq('1.23 4.5 67.8')
      end        
    end
  
  
    context 'operators:' do
      it 'unique and valid' do
        data = "+-*^%/<<=>>==!="
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("+ - * ^ % / < <= > >= = !=")
      end
      
      it 'multiple' do
        data = "++ +"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("+ + +")
      end      
    end
    
    
    
    context 'and:' do
      it 'just one' do
        data = "and"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("and")
      end
    
      it 'multiple' do
        data = "andand and"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("and and and")
      end
    end
    
    
    
    context 'bool:' do
      it 'just one' do
        data = "bool"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("bool")
      end
    
      it 'multiple' do
        data = "boolbool bool"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("bool bool bool")
      end
    end
    
    
    
    context 'cos:' do
      it 'just one' do
        data = "cos"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("cos")
      end
    
      it 'multiple' do
        data = "coscos cos"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("cos cos cos")
      end
    end
    
    
    
    context 'false:' do
      it 'just one' do
        data = "false"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("false")
      end
    
      it 'multiple' do
        data = "falsefalse false"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("false false false")
      end
    end
    
    
    
    context 'if:' do
      it 'just one' do
        data = "if"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("if")
      end
    
      it 'multiple' do
        data = "ifif if"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("if if if")
      end
    end
    
    
    
    context 'int:' do
      it 'just one' do
        data = "int"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("int")
      end
    
      it 'multiple' do
        data = "intint int"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("int int int")
      end
    end
    
    
    
    context 'let:' do
      it 'just one' do
        data = "let"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("let")
      end
    
      it 'multiple' do
        data = "letlet let"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("let let let")
      end
    end
    
    
    
    context 'not:' do
      it 'just one' do
        data = "not"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("not")
      end
    
      it 'multiple' do
        data = "notnot not"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("not not not")
      end
    end
    
    
    
    context 'or:' do
      it 'just one' do
        data = "or"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("or")
      end
    
      it 'multiple' do
        data = "oror or"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("or or or")
      end
    end
    
    
    
    context 'sin:' do
      it 'just one' do
        data = "sin"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("sin")
      end
    
      it 'multiple' do
        data = "sinsin sin"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("sin sin sin")
      end
    end
    
    
    
    context 'stdout:' do
      it 'just one' do
        data = "stdout"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("stdout")
      end
    
      it 'multiple' do
        data = "stdoutstdout stdout"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("stdout stdout stdout")
      end
    end
    
    
    
    context 'string:' do
      it 'just one' do
        data = "string"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("string")
      end
    
      it 'multiple' do
        data = "stringstring string"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("string string string")
      end
    end
    
    
    
    context 'tan:' do
      it 'just one' do
        data = "tan"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("tan")
      end
    
      it 'multiple' do
        data = "tantan tan"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("tan tan tan")
      end
    end
    
    
    
    context 'true:' do
      it 'just one' do
        data = "true"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("true")
      end
    
      it 'multiple' do
        data = "truetrue true"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("true true true")
      end
    end
    
    
    
    context 'while:' do
      it 'just one' do
        data = "while"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("while")
      end
    
      it 'multiple' do
        data = "whilewhile while"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("while while while")
      end
    end
    
    
  end
end