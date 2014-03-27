shared_examples "arguments mapper returning page params" do
  it "matches the args and creates a json object that maps the args" do
    res = Cc::Api::Parser::ArgumentsMapper.map args
    expected_res = { :page => 1 }
    res.should eq expected_res
  end
end
