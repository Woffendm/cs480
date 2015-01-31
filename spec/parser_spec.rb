require_relative '../parser2'

describe Parser do
  it 'can parse operators' do
    data = "+-*^%/<<=>>==!="
    expect(Parser.parse(data).map{|t| t.to_s}.join(" ")).
    to eq("+ - * ^ % / < <= > >= = !=")
  end
end