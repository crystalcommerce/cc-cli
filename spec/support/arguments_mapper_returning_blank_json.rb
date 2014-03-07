shared_examples "arguments mapper returning blank json" do
  it "matches the args and creates a json object that maps the args" do
    res = Cc::Api::Parser::ArgumentsMapper.map args
    expected_res = {}
    res.should eq expected_res
  end
end
