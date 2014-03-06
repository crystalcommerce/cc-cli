require 'cc/api/parser/json_parser'
require 'json'

LATTICE_PRODUCTS_RESPONSE = IO.read("spec/dummy_data/lattice_products.json") # sample json response 
LATTICE_STORES_RESPONSE = IO.read("spec/dummy_data/lattice_stores.json") # sample json response 

#TODO: Dry this up
describe Cc::Api::Parser::JsonParser do
  describe "parse" do
    context "lattice" do
      context "products" do
        it "returns json object when arguments are valid" do
          json = JSON.parse(LATTICE_PRODUCTS_RESPONSE)
          result = Cc::Api::Parser::JsonParser.reduce "lattice-products", json, []

          result.first[:store_name].should_not eq nil
          result.first[:qty].should_not eq nil
          result.first[:inventory_qty].should_not eq nil
          result.first[:sell_price].should_not eq nil
          result.first[:buy_price].should_not eq nil
        end

        it "returns blank when response json variants response is blank" do
          json = JSON.parse('{"product":{"product_id":123,"variants":[]}}')
          result = Cc::Api::Parser::JsonParser.reduce "lattice-products", json, []
        end

        it "returns blank when response json response is nil" do
          json = nil
          result = Cc::Api::Parser::JsonParser.reduce "lattice-products", json, []
        end
      end

      context "stores" do
        it "returns json object when arguments are valid" do
          json = JSON.parse(LATTICE_STORES_RESPONSE)
          result = Cc::Api::Parser::JsonParser.reduce "lattice-stores", json, []

          result.first[:name].should_not eq nil
          result.first[:postal_code].should_not eq nil
          result.first[:url].should_not eq nil
        end

        it "returns blank when json response is nil" do
          json = nil
          result = Cc::Api::Parser::JsonParser.reduce "lattice-stores", json, []
        end
      end

      context "offers" do
        it "returns json object when arguments are valid" do
          json = JSON.parse(LATTICE_OFFERS_RESPONSE)
          result = Cc::Api::Parser::JsonParser.reduce "lattice-offers", json, []

          result.first[:name].should_not eq nil
          result.first[:buy_price].should_not eq nil
          result.first[:store_credit_buy_price].should_not eq nil
          result.first[:qty].should_not eq nil
          result.first[:web_qty].should_not eq nil
        end

        it "returns blank when json response is nil" do
          json = nil
          result = Cc::Api::Parser::JsonParser.reduce "lattice-stores", json, []
        end
      end
    end

    context "catalog" do
      context "products" do
        it "returns json object when arguments are valid" do
          json = JSON.parse(CATALOG_PRODUCTS_RESPONSE)
          result = Cc::Api::Parser::JsonParser.reduce "catalog-products", json, []

          result.first[:name].should_not eq nil
          result.first[:seoname].should_not eq nil
          result.first[:category_name].should_not eq nil
          result.first[:weight].should_not eq nil
          result.first[:description].should_not eq nil
        end
      end

      context "product types" do
        it "returns json object when arguments are valid" do
          json = JSON.parse(CATALOG_PRODUCT_TYPES_RESPONSE)
          result = Cc::Api::Parser::JsonParser.reduce "catalog-product_types", json, []

          result.first[:name].should_not eq nil
          result.first[:default_weight].should_not eq nil
          result.first[:amazon_search_index].should_not eq nil
          result.first[:weight].should_not eq nil
        end
      end

      context "stores" do
        it "returns json object when arguments are valid" do
          json = JSON.parse(CATALOG_STORES_RESPONSE)
          result = Cc::Api::Parser::JsonParser.reduce "catalog-stores", json, []

          result.first[:name].should_not eq nil
          result.first[:address1].should_not eq nil
          result.first[:address2].should_not eq nil
          result.first[:postal_code].should_not eq nil
          result.first[:city].should_not eq nil
          result.first[:state].should_not eq nil
          result.first[:country].should_not eq nil
          result.first[:url].should_not eq nil
          result.first[:latitude].should_not eq nil
          result.first[:longitude].should_not eq nil
        end
      end
    end
  end
end
