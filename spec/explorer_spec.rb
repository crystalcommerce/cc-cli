require 'spec_helper'

#TODO Dry this up
describe Cc::Api::Explorer::CLI do
  let(:cc) { cc = Cc::Api::Explorer::CLI.new }

  context "lattice" do
    let(:skus) { ["123abc", "456def"] }
    context "products" do
      let(:id) { "123" }
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
          printed = capture_stdout do
            cc.latticeproducts "wrong", "arguments"
          end

          printed.should eq "Error. Please run 'cc' for a list of available commands and their corresponding usage\n"
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

    context "offers" do
      context "something is returned" do
        it "returns something" do
          stub_request(:post, "http://lattice.crystalcommerce.com/api/v1/offers").
            with(:body => "{\"search\":{\"skus\":{\"201750\":[\"123abc\",\"456def\"]}}}", :headers => {"Content-Type" => "application/json"}).
            to_return(:status => 200, :body => LATTICE_OFFERS_RESPONSE, :headers => {"Content-Type" => "application/json"})

            cc.latticeoffers "--id", "201750", "--skus", "#{skus.join(',')}"
        end
      end
    end
  end
  
  context "catalog" do
    context "products" do
      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://catalog.crystalcommerce.com/api/v1/products").
            to_return(:status => 200, :body => CATALOG_PRODUCTS_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          cc.catalogproducts 
        end
      end
    end

    context "product_types" do
      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://catalog.crystalcommerce.com/api/v1/product_types").
            to_return(:status => 200, :body => CATALOG_PRODUCT_TYPES_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          cc.catalogproducttypes
        end
      end
    end

    context "stores" do
      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://catalog.crystalcommerce.com/api/v1/stores").
            to_return(:status => 200, :body => CATALOG_STORES_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          cc.catalogstores
        end
      end
    end

    context "categories" do
      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://catalog.crystalcommerce.com/api/v1/categories").
            to_return(:status => 200, :body => CATALOG_CATEGORIES_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          cc.catalogcategories
        end
      end
    end
  end
end
