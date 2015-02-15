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
  
    

  it 'can parse really difficult things correctly' do
    data = "if+string/stdout**not and bool<=:=and id"
    expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
    to eq("if + string / stdout * * not and bool <= := and id")
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
        data = '1+23-45sin 67'
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
        data = '1.23+4.5sin 67.8'
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq('1.23 + 4.5 sin 67.8')
      end    
      
      it 'behaves properly when presented with multiple periods' do
        data = '1.23.4.5.67.8'
        expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
        to eq('1.23 4.5 67.8')
      end   
      
      context 'can deal with stupid C syntax' do
        it 'INTe+INT' do
          data = '1e+2'
          expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
          to eq('1e+2')
        end
        
        it 'REALe+INT' do
          data = '1.2e+2'
          expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
          to eq('1.2e+2')
        end
        
        it 'REALE+INT' do
          data = '1.2E+2'
          expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
          to eq('1.2E+2')
        end
        
        it 'INTe-INT' do
          data = '1e-2'
          expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
          to eq('1e-2')
        end
        
        it 'REALe-INT' do
          data = '1.2e-2'
          expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
          to eq('1.2e-2')
        end
        
        it 'INTeINT' do
          data = '1e2'
          expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
          to eq('1e2')
        end
        
        it 'REALe+INT' do
          data = '1.2e2'
          expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
          to eq('1.2e2')
        end
        
        it 'INTeINTe2' do
          data = '1e2e2'
          expect(Parser.parse(data, true, quiet).map{|t| t.to_s}.join(" ")).
          to eq('1e2 e2')
        end
        
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
        data = "a an and aa ana anda"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Logic, Id, Id, Id])
      end
    end
    
    
    
    context 'bool:' do
      it 'just one' do
        data = "bool"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("bool")
      end
    
      it 'multiple' do
        data = "b bo boo bool ba boa booa boola"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Id, Type, Id, Id, Id, Id])
      end
    end
    
    
    
    context 'cos:' do
      it 'just one' do
        data = "cos"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("cos")
      end
    
      it 'multiple' do
        data = "c co cos ca coa cosa"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Function, Id, Id, Id])
      end
    end
    
    
    
    context 'false:' do
      it 'just one' do
        data = "false"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("false")
      end
    
      it 'multiple' do
        data = "f fa fal fals false fx fax falx falsx falsex"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Id, Id, MBoolean, Id, Id, Id, Id, Id])
      end
    end
    
    
    
    context 'if:' do
      it 'just one' do
        data = "if"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("if")
      end
    
      it 'multiple' do
        data = "i if ifa"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, MIf, Id])
      end
    end
    
    
    
    context 'int:' do
      it 'just one' do
        data = "int"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("int")
      end
    
      it 'multiple' do
        data = "in int intx"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Type, Id])
      end
    end
    
    
    
    context 'let:' do
      it 'just one' do
        data = "let"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("let")
      end
    
      it 'multiple' do
        data = "l le let la lea leta"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, MLet, Id, Id, Id])
      end
    end
    
    
    
    context 'not:' do
      it 'just one' do
        data = "not"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("not")
      end
    
      it 'multiple' do
        data = "n no not nota"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Logic, Id])
      end
    end
    
    
    
    context 'or:' do
      it 'just one' do
        data = "or"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("or")
      end
    
      it 'multiple' do
        data = "o or ora"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Logic, Id])
      end
    end
    
    
    
    context 'sin:' do
      it 'just one' do
        data = "sin"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("sin")
      end
    
      it 'multiple' do
        data = "s si sin sina"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Function, Id])
      end
    end
    
    
    
    context 'stdout:' do
      it 'just one' do
        data = "stdout"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("stdout")
      end
    
      it 'multiple' do
        data = "s st std stdo stdou stdout stdouta"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Id, Id, Id, Function, Id])
      end
    end
    
    
    
    context 'string:' do
      it 'just one' do
        data = "string"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("string")
      end
    
      it 'multiple' do
        data = "s st str stri strin string stringa"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Id, Id, Id, Type, Id])
      end
    end
    
    
    
    context 'tan:' do
      it 'just one' do
        data = "tan"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("tan")
      end
    
      it 'multiple' do
        data = "t ta tan tana"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Function, Id])
      end
    end
    
    
    
    context 'true:' do
      it 'just one' do
        data = "true"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("true")
      end
    
      it 'multiple' do
        data = "t tr tru true trua"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Id, MBoolean, Id])
      end
    end
    
    
    
    context 'while:' do
      it 'just one' do
        data = "while"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.to_s}.join(" ")).
        to eq("while")
      end
    
      it 'multiple' do
        data = "w wh whi whil while whila"
        expect(Parser.parse(data, nofail, quiet).map{|t| t.class}).
        to eq([Id, Id, Id, Id, MWhile, Id])
      end
    end
    
    
  end
end