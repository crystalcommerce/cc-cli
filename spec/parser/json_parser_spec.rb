require 'cc/api/parser/json_parser'
require 'json'

LATTICE_PRODUCTS_RESPONSE = IO.read("spec/dummy_data/lattice_products.json") # sample json response 

describe Cc::Api::Parser::JsonParser do
  describe "parse" do
    context "lattice" do

      it "returns json object when arguments are valid" do
        json = JSON.parse(LATTICE_PRODUCTS_RESPONSE)
        result = Cc::Api::Parser::JsonParser.reduce "lattice-products", json, []

        result.first[:store_name].should_not eq nil
        result.first[:qty].should_not eq nil
        result.first[:inventory_qty].should_not eq nil
        result.first[:sell_price].should_not eq nil
        result.first[:buy_price].should_not eq nil
      end
    end
  end
end
