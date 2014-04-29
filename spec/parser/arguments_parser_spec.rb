require 'spec_helper'

#TODO: Dry this up
describe Cc::Api::Parser::ArgumentsParser do
  before(:each) do
    allow(Cc::Api::Util::ConfigReader).to receive(:pair).and_return "abc:123"
  end

  describe "parse" do
    context "market_data" do
      let(:url) { "https://api.crystalcommerce.com/v1/market_data/" }
      let(:rand) { "123" }

      context "products" do
        let(:expected_result) { {request: {url: url + "products/" + rand + "?skus[]=" + rand } } }
        let(:args) { { :action => "market_data-products", :params => { :id => rand, :skus => [ rand ] } } }

        it_behaves_like "arguments parser returning expected result"
      end

      context "stores" do
        let(:expected_result) { {request: { url: url + "stores", :target_key_chain => "" } } }
        let(:args) { {:action => "market_data-stores"} }

        it_behaves_like "arguments parser returning expected result"
      end

      context "offers" do
        let(:expected_result) { {request: { url: url + "offers", :body=>{"search"=>{"skus"=>{"123"=>["123"]}}}, method: "POST"} } }
        let(:args) { {:action => "market_data-offers", :params => { :id => rand, :skus => [rand] } } }

        it_behaves_like "arguments parser returning expected result"
      end
    end

    context "catalog" do
      context "products" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/products?page=1" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { {:action => "catalog-products", :params => {:page => 1} } }

        it_behaves_like "arguments parser returning expected result"
      end

      context "product types" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/product_types?page=1" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { { :action => "catalog-product_types", :params => {:page => 1} } }

        it_behaves_like "arguments parser returning expected result"
      end

      context "product types" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/stores" }
        let(:expected_result) { { request: { url: url, :target_key_chain=>"stores" } } }
        let(:args) { { :action => "catalog-stores" } }

        it_behaves_like "arguments parser returning expected result"
      end

      context "categories" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/categories?page=1" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { { :action => "catalog-categories", :params => {:page => 1} } }

        it_behaves_like "arguments parser returning expected result"
      end
    end

    context "store" do
      context "products" do
        let(:url) { "https://arux-api.crystalcommerce.com/v1/products?page=2" }
        let(:token) { "123" }
        let(:expected_result) { { request: { url: url, token: token } } }
        let(:args) { { :action => "store-products", :params => { :token => token, :store => "arux", :page => 2 } } }

        it_behaves_like "arguments parser returning expected result"
      end
    end
  end
end
