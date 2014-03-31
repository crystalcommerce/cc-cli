shared_examples "json parser" do
  it "returns json object when arguments are valid" do
    json = JSON.parse(json_response)
    target = Cc::Api::Parser::ArgumentsMapper.get_target_key_chain action

    array = Cc::Api::Util::KeyChainsGetter.get_target_array json, target, product_id

    result = Cc::Api::Parser::JsonParser.vanilla_reduce array, chosen_columns

    chosen_columns.each do |chosen_column|
      result.first[chosen_column].should_not eq nil
    end
  end

  it "returns blank array if json response is blank" do
    json = JSON.parse(blank_json_response)
    target = Cc::Api::Parser::ArgumentsMapper.get_target_key_chain action
    array = Cc::Api::Util::KeyChainsGetter.get_target_array json, target

    result = Cc::Api::Parser::JsonParser.vanilla_reduce array, chosen_columns

    result.should eq [] 
  end

  it "returns blank array if json response is nil" do
    json = nil
    target = Cc::Api::Parser::ArgumentsMapper.get_target_key_chain action
    array = Cc::Api::Util::KeyChainsGetter.get_target_array json, target

    result = Cc::Api::Parser::JsonParser.vanilla_reduce array, chosen_columns

    result.should eq [] 
  end

  it "throws exception whenever chosen_columns are not valid" do
    json = nil
    target = Cc::Api::Parser::ArgumentsMapper.get_target_key_chain action
    array = Cc::Api::Util::KeyChainsGetter.get_target_array json, target

    result = Cc::Api::Parser::JsonParser.vanilla_reduce array, ["invalid", "columns"]
  end

end
