require_relative '../parser2'

describe Parser do
  
  context 'can keep parsing if:' do    
    it 'has the start of something valid, then it fails, but there was something valid inside it' do
      data = "bocosboocos"
      expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
      to eq("cos cos")
    end
    
    it 'all invalid' do
      data = "zxy~?|"
      expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
      to eq("")
    end
  end


  it 'can parse really difficult things correctly' do
    data = "if+string/stdout**notandbool<=:=and"
    expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
    to eq("if + string / stdout * * not and bool <= := and")
  end

  
  context 'can parse:' do
  
    context 'operators:' do
      it 'unique and valid' do
        data = "+-*^%/<<=>>==!="
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("+ - * ^ % / < <= > >= = !=")
      end
      
      it 'multiple' do
        data = "++ +"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("+ + +")
      end      
    end
    
    
    
    context 'and:' do
      it 'just one' do
        data = "and"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("and")
      end
    
      it 'multiple' do
        data = "andand and"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("and and and")
      end
      
      it 'with partials' do
        data = "aanandanr"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("and")
      end
    end
    
    
    
    context 'bool:' do
      it 'just one' do
        data = "bool"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("bool")
      end
    
      it 'multiple' do
        data = "boolbool bool"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("bool bool bool")
      end
      
      it 'with partials' do
        data = "bbobooboolbozboox"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("bool")
      end
    end
    
    
    
    context 'cos:' do
      it 'just one' do
        data = "cos"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("cos")
      end
    
      it 'multiple' do
        data = "coscos cos"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("cos cos cos")
      end
      
      it 'with partials' do
        data = "ccocosczcox"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("cos")
      end
    end
    
    
    
    context 'false:' do
      it 'just one' do
        data = "false"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("false")
      end
    
      it 'multiple' do
        data = "falsefalse false"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("false false false")
      end
      
      it 'with partials' do
        data = "falsfalse"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("false")
      end
    end
    
    
    
    context 'if:' do
      it 'just one' do
        data = "if"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("if")
      end
    
      it 'multiple' do
        data = "ifif if"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("if if if")
      end
      
      it 'with partials' do
        data = "iifix"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("if")
      end
    end
    
    
    
    context 'int:' do
      it 'just one' do
        data = "int"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("int")
      end
    
      it 'multiple' do
        data = "intint int"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("int int int")
      end
      
      it 'with partials' do
        data = "iinintixinx"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("int")
      end
    end
    
    
    
    context 'let:' do
      it 'just one' do
        data = "let"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("let")
      end
    
      it 'multiple' do
        data = "letlet let"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("let let let")
      end
      
      it 'with partials' do
        data = "lleletlxlex"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("let")
      end
    end
    
    
    
    context 'not:' do
      it 'just one' do
        data = "not"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("not")
      end
    
      it 'multiple' do
        data = "notnot not"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("not not not")
      end
      
      it 'with partials' do
        data = "nnonotnxnox"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("not")
      end
    end
    
    
    
    context 'or:' do
      it 'just one' do
        data = "or"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("or")
      end
    
      it 'multiple' do
        data = "oror or"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("or or or")
      end
      
      it 'with partials' do
        data = "oorox"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("or")
      end
    end
    
    
    
    context 'sin:' do
      it 'just one' do
        data = "sin"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("sin")
      end
    
      it 'multiple' do
        data = "sinsin sin"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("sin sin sin")
      end
      
      it 'with partials' do
        data = "ssisinsxsix"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("sin")
      end
    end
    
    
    
    context 'stdout:' do
      it 'just one' do
        data = "stdout"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("stdout")
      end
    
      it 'multiple' do
        data = "stdoutstdout stdout"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("stdout stdout stdout")
      end
      
      it 'with partials' do
        data = "sststdstdostdoustdoutsxstxstdxstdoxstdoux"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("stdout")
      end
    end
    
    
    
    context 'string:' do
      it 'just one' do
        data = "string"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("string")
      end
    
      it 'multiple' do
        data = "stringstring string"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("string string string")
      end
      
      it 'with partials' do
        data = "sststrstristrinstringsxstxstrxstrixstrinx"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("string")
      end
    end
    
    
    
    context 'tan:' do
      it 'just one' do
        data = "tan"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("tan")
      end
    
      it 'multiple' do
        data = "tantan tan"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("tan tan tan")
      end
      
      it 'with partials' do
        data = "ttatantxtax"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("tan")
      end
    end
    
    
    
    context 'true:' do
      it 'just one' do
        data = "true"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("true")
      end
    
      it 'multiple' do
        data = "truetrue true"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("true true true")
      end
      
      it 'with partials' do
        data = "ttrtrutruetxtrxtrux"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("true")
      end
    end
    
    
    
    context 'while:' do
      it 'just one' do
        data = "while"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("while")
      end
    
      it 'multiple' do
        data = "whilewhile while"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("while while while")
      end
      
      it 'with partials' do
        data = "wwhwhiwhilwhilewxwhxwhixwhilx"
        expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
        to eq("while")
      end
    end
    
    
  end
end