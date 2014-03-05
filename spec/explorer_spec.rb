require 'cc/api/explorer'
require 'webmock/rspec'

LATTICE_PRODUCTS_RESPONSE = IO.read("spec/dummy_data/lattice_products.json") # sample json response 
LATTICE_STORES_RESPONSE = IO.read("spec/dummy_data/lattice_stores.json") # sample json response 

describe Cc::Api::Explorer::CLI do
  context "lattice" do
    let(:cc) { cc = Cc::Api::Explorer::CLI.new }

    context "products" do
      let(:id) { "123" }
      let(:skus) { ["123abc", "456def"] }
      let(:args) { "--id #{id} --sku #{skus}" }

      context "something is returned" do
        before(:each) do
          stub_request(:get, "http://lattice.crystalcommerce.com/api/v1/products/#{id}?skus[]=#{skus[0]}").
            to_return(:status => 200, :body => LATTICE_PRODUCTS_RESPONSE, :headers => {"Content-Type" => "application/json"})

          stub_request(:get, "http://lattice.crystalcommerce.com/api/v1/products/#{id}?skus[]=#{skus[0]}&skus[]=#{skus[1]}").
            to_return(:status => 200, :body => LATTICE_PRODUCTS_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          cc.latticeproducts "--id", "123", "--skus", "123abc"
        end

        it "returns something if arguments are correct for multiple skus" do
          cc.latticeproducts "--id", "123", "--skus", "#{skus.join(',')}"
        end
      end

      context "something is not returned" do
        it "returns an exception if arguments are not correct" do
          expect {
            cc.latticeproducts "wrong", "arguments"
          }.to raise_error Cc::Api::Parser::CLIArgumentsException
        end

        it "returns blank if blank variants was returned" do
          stub_request(:get, "http://lattice.crystalcommerce.com/api/v1/products/#{id}?skus[]=#{skus[0]}&skus[]=#{skus[1]}").
            to_return(:status => 200, :body => '{"product":{"product_id":201750,"variants":[]}}', :headers => {"Content-Type" => "application/json"})

            cc.latticeproducts "--id", "123", "--skus", "#{skus.join(',')}"
        end

        it "returns blank if nil json was returned" do
          stub_request(:get, "http://lattice.crystalcommerce.com/api/v1/products/#{id}?skus[]=#{skus[0]}&skus[]=#{skus[1]}").
            to_return(:status => 200, :body => nil, :headers => {"Content-Type" => "application/json"})

            cc.latticeproducts "--id", "123", "--skus", "#{skus.join(',')}"
        end
      end
    end

    context "stores" do
      context "something is returned" do
        it "returns something" do
          stub_request(:get, "http://lattice.crystalcommerce.com/api/v1/stores").
            to_return(:status => 200, :body => LATTICE_STORES_RESPONSE, :headers => {"Content-Type" => "application/json"})

          cc.latticestores
        end
      end

      context "something is not returned" do
        it "returns nothing" do
          stub_request(:get, "http://lattice.crystalcommerce.com/api/v1/stores").
            to_return(:status => 200, :body => nil, :headers => {"Content-Type" => "application/json"})

          cc.latticestores
        end
      end
    end
  end
end
