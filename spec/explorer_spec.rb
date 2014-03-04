require 'cc/api/explorer'
require 'webmock/rspec'

LATTICE_PRODUCTS_RESPONSE = IO.read("spec/dummy_data/lattice_products.json") # sample json response 

describe Cc::Api::Explorer::CLI do
  context "lattice" do
    context "products" do
      let(:id) { "123" }
      let(:skus) { "123abc" }
      let(:args) { "--id #{id} --sku #{skus}" }
      let(:cc) { cc = Cc::Api::Explorer::CLI.new }

      before(:each) do
        stub_request(:get, "http://lattice.crystalcommerce.com/api/v1/products/#{id}?skus=#{skus}").
          to_return(:status => 200, :body => LATTICE_PRODUCTS_RESPONSE, :headers => {"Content-Type" => "application/json"})
      end

      it "returns something if arguments are correct" do
        cc.latticeproducts "--id", "123", "--sku", "123abc"
      end

      it "returns an exception if arguments are not correct" do
        expect {
          cc.latticeproducts "wrong", "arguments"
        }.to raise_error Cc::Api::Parser::CLIArgumentsException
      end
    end
  end
end
