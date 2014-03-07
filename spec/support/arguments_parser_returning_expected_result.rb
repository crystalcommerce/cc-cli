shared_examples "arguments parser returning expected result" do
  it "returns json object when arguments are valid" do
    res = Cc::Api::Parser::ArgumentsParser.parse args
    res.should eq expected_result
  end
end
