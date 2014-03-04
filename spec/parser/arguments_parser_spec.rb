require 'cc/api/parser/arguments_parser'

describe Cc::Api::Parser::ArgumentsParser do
  describe "parse" do
    context "lattice" do
      let(:url) { "http://lattice.crystalcommerce.com/api/v1/" }
      let(:rand) { "123" }
      let(:expected_result) { {request: url + "products/" + rand + "?skus[]=" + rand } }

      it "returns json object when arguments are valid" do
        args = ["lattice-products", "--id", rand, "--skus", rand]
        res = Cc::Api::Parser::ArgumentsParser.parse args
        res.should eq expected_result
      end

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
  end
end
