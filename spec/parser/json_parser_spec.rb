require 'cc/api/parser/json_parser'
require 'json'

describe Cc::Api::Parser::JsonParser do
  context "'vanilla' reduce" do
    let(:product_id) { nil }
    context "market_data" do
      context "products" do
        let(:json_response) { MARKET_DATA_PRODUCTS_RESPONSE }
        let(:blank_json_response) {'{"product":{"product_id":123,"variants":[]}}'}
        let(:action) { "market_data-products" }
        let(:chosen_columns) { ["store_variant.sku", "store_variant.store_name", "store_variant.store_business_name", "store_variant.sell_price.money.cents"] }

        it_behaves_like "json parser"
       
      end

      context "offers" do
        let(:product_id) { "201750" }
        let(:json_response) { MARKET_DATA_OFFERS_RESPONSE }
        let(:blank_json_response) {'{"201750" : []}'}
        let(:action) { "market_data-offers" }
        let(:chosen_columns) { ["buy_price.cents", "qty", "product_url", "inventory_qty"] }

        it_behaves_like "json parser"
      end

      context "stores" do
        let(:json_response) { MARKET_DATA_STORES_RESPONSE }
        let(:blank_json_response) {'[]'}
        let(:action) { "market_data-stores" }
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
        context "valid chosen columns" do
          let(:json_response) { CATALOG_PRODUCT_TYPES_RESPONSE }
          let(:blank_json_response) {'{"product_types":[]}'}
          let(:action) { "catalog-product_types" }
          let(:chosen_columns) { ["name", "default_weight", "variant_dimensions.0.name"] }

          it_behaves_like "json parser"
        end

        context "invalid chosen columns having index in variant_diments.<index>.name out of bounds" do
          let(:json_response) { CATALOG_PRODUCT_TYPES_RESPONSE }
          let(:blank_json_response) {'{"product_types":[]}'}
          let(:action) { "catalog-product_types" }
          let(:chosen_columns) { ["name", "default_weight", "variant_dimensions.500.name"] }

          it_behaves_like "json parser"
        end
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
      context "valid chosen columns" do
        let(:json_response) { STORE_PRODUCTS_RESPONSE }
        let(:blank_json_response) {'{"paginated_collection": {"entries" : []} }'}
        let(:action) { "store-products" }
        let(:chosen_columns) { ["product.weight", "product.qty", "product.default_variant.variant.descriptors.0.variant_descriptor.name"] }

        it_behaves_like "json parser"
      end

      context "invalid chosen columns having index in variant_diments.<index>.name out of bounds" do
        let(:json_response) { STORE_PRODUCTS_RESPONSE }
        let(:blank_json_response) {'{"paginated_collection": {"entries" : []} }'}
        let(:action) { "store-products" }
        let(:chosen_columns) { ["product.weight", "product.qty", "product.default_variant.variant.descriptors.500.variant_descriptor.name"] }

        it_behaves_like "json parser"

      end
    end
  end
end
