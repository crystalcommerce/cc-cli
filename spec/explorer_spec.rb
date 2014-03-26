require 'spec_helper'

#TODO Dry this up
describe Cc::Api::Explorer::CLI do
  before(:each) do
    allow(Cc::Api::Util::ConfigReader).to receive(:get_keys).and_return "abc:123"
  end

  let(:cc) { cc = Cc::Api::Explorer::CLI.new }

  context "lattice" do
    let(:skus) { ["123abc", "456def"] }
    context "products" do
      let(:expected_print_substring) {"┃      matt-environment          ┃      2                         ┃      2                         ┃      0                         ┃      0                         ┃"}
      let(:id) { "123" }
      let(:args) { "--id #{id} --sku #{skus}" }

      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/lattice/products/#{id}?skus[]=#{skus[0]}").
            to_return(:status => 200, :body => LATTICE_PRODUCTS_RESPONSE, :headers => {"Content-Type" => "application/json"})

          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/lattice/products/#{id}?skus[]=#{skus[0]}&skus[]=#{skus[1]}").
            to_return(:status => 200, :body => LATTICE_PRODUCTS_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do

          printed = capture_stdout do
            args = ["latticeproducts", "--id", "123", "--skus", "123abc"]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to match expected_print_substring
        end

        it "returns something if arguments are correct for multiple skus" do
          
          printed = capture_stdout do
            args = ["latticeproducts", "--id", "123", "--skus", skus.join(',')]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to match expected_print_substring
        end
      end

      context "something is not returned" do
        it "returns an exception if arguments are not correct" do
          printed = capture_stdout do
            args = ["latticeproducts", "wrong", "arguments"]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          printed.should eq "" #an error is printed here from Thor
        end

        it "returns blank if blank variants was returned" do
          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/lattice/products/#{id}?skus[]=#{skus[0]}&skus[]=#{skus[1]}").
            to_return(:status => 200, :body => '{"product":{"product_id":201750,"variants":[]}}', :headers => {"Content-Type" => "application/json"})

          printed = capture_stdout do
            args = ["latticeproducts", "--id", "123", "--skus", skus.join(',')]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to_not match expected_print_substring
        end

        it "returns blank if nil json was returned" do
          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/lattice/products/#{id}?skus[]=#{skus[0]}&skus[]=#{skus[1]}").
            to_return(:status => 200, :body => nil, :headers => {"Content-Type" => "application/json"})


          printed = capture_stdout do
            args = ["latticeproducts", "--id", "123", "--skus", skus.join(',')]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to_not match expected_print_substring
        end
      end
    end

    context "stores" do
      let(:expected_print_substring) { "┃      Lettie Traffanstedt'      ┃                                ┃                                ┃" }
      context "something is returned" do
        it "returns something" do
          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/lattice/stores").
            to_return(:status => 200, :body => LATTICE_STORES_RESPONSE, :headers => {"Content-Type" => "application/json"})

          printed = capture_stdout do 
            args = ["latticestores"]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to match expected_print_substring
        end
      end

      context "something is not returned" do
        it "returns nothing" do
          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/lattice/stores").
            to_return(:status => 200, :body => nil, :headers => {"Content-Type" => "application/json"})

          printed = capture_stdout do 
            args = ["latticestores"]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to_not match expected_print_substring
        end
      end
    end

    context "offers" do
      let(:expected_print_substring) { "┃      lettie-traffanstedt       ┃      109                       ┃      141                       ┃                                ┃                                ┃" }
      context "something is returned" do
        it "returns something" do
          stub_request(:post, "https://abc:123@api.crystalcommerce.com/v1/lattice/offers").
            with(:body => "{\"search\":{\"skus\":{\"201750\":[\"123abc\",\"456def\"]}}}", :headers => {"Content-Type" => "application/json"}).
            to_return(:status => 200, :body => LATTICE_OFFERS_RESPONSE, :headers => {"Content-Type" => "application/json"})

            printed = capture_stdout do
              args = ["latticeoffers", "--id", "201750", "--skus", skus.join(',')]
              options = Cc::Api::Explorer::CLI.start(args)
            end

            expect(printed).to match expected_print_substring
        end
      end
    end
  end
  
  context "catalog" do
    context "products" do
      let(:expected_print_substring) { "┃      Abyssal Specter           ┃      abyssal_specter           ┃      Eighth Edition            ┃      0.0                       ┃                                ┃" }
      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/catalog/products").
            to_return(:status => 200, :body => CATALOG_PRODUCTS_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          
          printed = capture_stdout do
            args = ["catalogproducts"]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to match expected_print_substring
        end
      end
    end

    context "product_types" do
      let(:expected_print_substring) { "┃      Pathfinder                ┃      2.0                       ┃      Toys                      ┃                                ┃" }
      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/catalog/product_types").
            to_return(:status => 200, :body => CATALOG_PRODUCT_TYPES_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          printed = capture_stdout do
            args = ["catalogproducttypes"]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to match expected_print_substring
        end
      end
    end

    context "stores" do
      let(:expected_print_substring) { "┃      PlayCCG.com               ┃      731 North 94th St         ┃      Unit 4                    ┃      98103                     ┃      Seattle                   ┃      WA                        ┃      US                        ┃" }
      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/catalog/stores").
            to_return(:status => 200, :body => CATALOG_STORES_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          printed = capture_stdout do
            args = ["catalogstores"]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to match expected_print_substring
        end
      end
    end

    context "categories" do
      let(:expected_print_substring) { "┃      Eighth Edition            ┃      eighth_edition            ┃                                ┃                                ┃      8E                        ┃      208                       ┃" }
      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://abc:123@api.crystalcommerce.com/v1/catalog/categories").
            to_return(:status => 200, :body => CATALOG_CATEGORIES_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          printed = capture_stdout do
            args = ["catalogcategories"]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to match expected_print_substring
        end
      end
    end
  end

  context "store" do
    context "products" do
      let(:expected_print_substring) { "┃      Ashnod's Cylix            ┃      ashnods_cylix             ┃                                ┃" }
      context "something is returned" do
        before(:each) do
          stub_request(:get, "https://abc-api.crystalcommerce.com/v1/products").with(:headers => {'Authorization' => 'OAuth 123'}).
            to_return(:status => 200, :body => STORE_PRODUCTS_RESPONSE, :headers => {"Content-Type" => "application/json"})
        end

        it "returns something if arguments are correct" do
          printed = capture_stdout do
            args = ["storeproducts", "--token", "123", "--store", "abc"]
            options = Cc::Api::Explorer::CLI.start(args)
          end

          expect(printed).to match expected_print_substring
        end
      end
    end
  end
end
