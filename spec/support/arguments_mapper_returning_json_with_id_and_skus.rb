shared_examples "arguments mapper returning json with id and skus" do
  it "matches the args and creates a json object that maps the args" do
    res = Cc::Api::Parser::ArgumentsMapper.map args
    expected_res = {id: rand, skus: [rand]}
    res.should eq expected_res
  end
end
