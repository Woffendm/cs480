require_relative '../parser2'

describe Parser do
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
    
  end
end