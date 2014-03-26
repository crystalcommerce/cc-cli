require 'spec_helper'

#TODO: Dry this up
describe Cc::Api::Parser::ArgumentsParser do
  before(:each) do
    allow(Cc::Api::Util::ConfigReader).to receive(:pair).and_return "abc:123"
  end

  describe "parse" do
    context "lattice" do
      let(:url) { "https://api.crystalcommerce.com/v1/lattice/" }
      let(:rand) { "123" }

      context "products" do
        let(:expected_result) { {request: {url: url + "products/" + rand + "?skus[]=" + rand } } }
        let(:args) { { :action => "lattice-products", :params => { :id => rand, :skus => [ rand ] } } }

        it_behaves_like "arguments parser returning expected result"
      end

      context "stores" do
        let(:expected_result) { {request: { url: url + "stores" } } }
        let(:args) { {:action => "lattice-stores"} }

        it_behaves_like "arguments parser returning expected result"
      end

      context "offers" do
        let(:expected_result) { {request: { url: url + "offers", :body=>{"search"=>{"skus"=>{"123"=>["123"]}}}, method: "POST"} } }
        let(:args) { {:action => "lattice-offers", :params => { :id => rand, :skus => [rand] } } }

        it_behaves_like "arguments parser returning expected result"
      end
    end

    context "catalog" do
      context "products" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/products" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { {:action => "catalog-products"} }

        it_behaves_like "arguments parser returning expected result"
      end

      context "product types" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/product_types" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { { :action => "catalog-product_types" } }

        it_behaves_like "arguments parser returning expected result"
      end

      context "product types" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/stores" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { { :action => "catalog-stores" } }

        it_behaves_like "arguments parser returning expected result"
      end

      context "categories" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/categories" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { { :action => "catalog-categories" } }

        it_behaves_like "arguments parser returning expected result"
      end
    end

    context "store" do
      context "products" do
        let(:url) { "https://arux-api.crystalcommerce.com/v1/products" }
        let(:token) { "123" }
        let(:expected_result) { { request: { url: url, token: token } } }
        let(:args) { { :action => "store-products", :params => { :token => token, :store => "arux" } } }

        it_behaves_like "arguments parser returning expected result"
      end
    end
  end
end
