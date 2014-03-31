require 'cc/api/parser/json_parser'
require 'json'

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
          #result.first[:url].should_not eq nil
          #result.first[:latitude].should_not eq nil
          #result.first[:longitude].should_not eq nil
        end
      end

      context "categories" do
        it "returns json object when arguments are valid" do
          json = JSON.parse(CATALOG_CATEGORIES_RESPONSE)
          result = Cc::Api::Parser::JsonParser.reduce "catalog-categories", json, []

          result.first[:name].should_not eq nil
          result.first[:seoname].should_not eq nil
          result.first[:description].should_not eq nil
          result.first[:available_on].should_not eq nil
          result.first[:set_code].should_not eq nil
          result.first[:product_type_id].should_not eq nil
        end
      end

    end

    context "store" do
      context "products" do
        it "returns json object when arguments are valid" do
          json = JSON.parse(STORE_PRODUCTS_RESPONSE)
          result = Cc::Api::Parser::JsonParser.reduce "store-products", json, []

          result.first[:name].should_not eq nil
          result.first[:seoname].should_not eq nil
          result.first[:description].should_not eq nil
        end
      end
    end
  end

  context "'vanilla' reduce" do
    let(:product_id) { nil }
    context "lattice" do
      context "products" do
        let(:json_response) { LATTICE_PRODUCTS_RESPONSE }
        let(:blank_json_response) {'{"product":{"product_id":123,"variants":[]}}'}
        let(:action) { "lattice-products" }
        let(:chosen_columns) { ["store_variant.sku", "store_variant.store_name", "store_variant.store_business_name", "store_variant.sell_price.money.cents"] }

        it_behaves_like "json parser"
       
      end

      context "offers" do
        let(:product_id) { "201750" }
        let(:json_response) { LATTICE_OFFERS_RESPONSE }
        let(:blank_json_response) {'{"201750" : []}'}
        let(:action) { "lattice-offers" }
        let(:chosen_columns) { ["buy_price.cents", "qty", "product_url", "inventory_qty"] }

        it_behaves_like "json parser"
      end

      context "stores" do
        let(:json_response) { LATTICE_STORES_RESPONSE }
        let(:blank_json_response) {'[]'}
        let(:action) { "lattice-stores" }
        let(:chosen_columns) { ["store.id", "store.name", "store.is_active", "store.country"] }

        it_behaves_like "json parser"
      end
    end

    context "catalog" do
      context "products" do
        let(:json_response) { CATALOG_PRODUCTS_RESPONSE }
        let(:blank_json_response) {'{"products":[]}'}
        let(:action) { "catalog-products" }
        let(:chosen_columns) { ["name", "seoname", "barcode", "photo.content_type"] }

        it_behaves_like "json parser"
      end

      context "product_types" do
        let(:json_response) { CATALOG_PRODUCT_TYPES_RESPONSE }
        let(:blank_json_response) {'{"product_types":[]}'}
        let(:action) { "catalog-product_types" }
        let(:chosen_columns) { ["name", "default_weight"] }

        it_behaves_like "json parser"
      end

      context "stores" do
        let(:json_response) { CATALOG_STORES_RESPONSE }
        let(:blank_json_response) {'{"stores":[]}'}
        let(:action) { "catalog-stores" }
        let(:chosen_columns) { ["name", "country"] }

        it_behaves_like "json parser"
      end

      context "categories" do
        let(:json_response) { CATALOG_CATEGORIES_RESPONSE }
        let(:blank_json_response) {'{"categories":[]}'}
        let(:action) { "catalog-categories" }
        let(:chosen_columns) { ["name", "seoname"] }

        it_behaves_like "json parser"
      end
    end

    context "stores" do
      let(:json_response) { STORE_PRODUCTS_RESPONSE }
      let(:blank_json_response) {'{"paginated_collection": {"entries" : []} }'}
      let(:action) { "store-products" }
      let(:chosen_columns) { ["product.weight", "product.qty"] }

      it_behaves_like "json parser"
    end
  end
end
