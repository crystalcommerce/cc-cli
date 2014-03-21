require 'spec_helper'

#TODO: Dry this up
describe Cc::Api::Parser::ArgumentsParser do
  before(:each) do
    allow(Cc::Api::Util::ConfigReader).to receive(:pair).and_return "abc:123"
  end

  describe "parse" do
    context "lattice" do
      let(:url) { "http://lattice.crystalcommerce.com/api/v1/" }
      let(:rand) { "123" }

      context "products" do
        let(:expected_result) { {request: {url: url + "products/" + rand + "?skus[]=" + rand } } }
        let(:args) { ["lattice-products", "--id", rand, "--skus", rand] }

        it_behaves_like "arguments parser returning expected result"

        # future version
        #it "returns json object with user's desired json response keys" do
        #  args = ["lattice-products", "--id", rand, "--sku", rand, "--cols", "store_name", "qty", "sell_price", "buy_price"]
        #  res = Cc::Api::Parser::ArgumentsParser.parse args
        #  result = { :request => expected_url, :json_response_keys => ["store_name", "qty", "sell_price", "buy_price"] }
        #  res.should eq result
        #end

        it "returns exception when arguments are invalid" do
          args = ["wrong arguments"]
          expect {
            res = Cc::Api::Parser::ArgumentsParser.parse args
          }.to raise_error Cc::Api::Parser::CLIArgumentsException
        end
      end

      context "stores" do
        let(:expected_result) { {request: { url: url + "stores" } } }
        let(:args) { ["lattice-stores"] }

        it_behaves_like "arguments parser returning expected result"
      end

      context "offers" do
        let(:expected_result) { {request: { url: url + "offers", :body=>{"search"=>{"skus"=>{"123"=>["123"]}}}, method: "POST"} } }
        let(:args) { ["lattice-offers", "--id", rand, "--skus", rand] }

        it_behaves_like "arguments parser returning expected result"
      end
    end

    context "catalog" do
      context "products" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/products" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { ["catalog-products"] }

        it_behaves_like "arguments parser returning expected result"
      end

      context "product types" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/product_types" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { ["catalog-product_types"] }

        it_behaves_like "arguments parser returning expected result"
      end

      context "product types" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/stores" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { ["catalog-stores"] }

        it_behaves_like "arguments parser returning expected result"
      end

      context "categories" do
        let(:url) { "https://api.crystalcommerce.com/v1/catalog/categories" }
        let(:expected_result) { { request: { url: url } } }
        let(:args) { ["catalog-categories"] }

        it_behaves_like "arguments parser returning expected result"
      end
    end
  end
end
