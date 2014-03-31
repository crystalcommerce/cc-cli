module Cc
  module Api
    module Parser
      class JsonParser
        def self.reduce action, json, cols
          case action
          when "lattice-products"
            self.reduce_for_lattice_products json, cols  
          when "lattice-stores"
            self.reduce_for_lattice_stores json, cols  
          when "lattice-offers"
            self.reduce_for_lattice_offers json, cols  
          when "catalog-products"
            self.reduce_for_catalog_products json, cols  
          when "catalog-product_types"
            self.reduce_for_catalog_product_types json, cols  
          when "catalog-stores"
            self.reduce_for_catalog_stores json, cols  
          when "catalog-categories"
            self.reduce_for_catalog_categories json, cols  
          when "store-products"
            self.reduce_for_store_products json, cols  
          else
            nil
          end
        end

        def self.vanilla_reduce array, cols
          result = []

          unless array.nil? 
            array.each do |j|
              hash = {}
              cols.each do |col|
                a = j
                col.split('.').each do |key|
                  a = a[key]
                end
                hash[col] = a || ""
              end
              result << hash
            end
          end
          result
        end 

        protected


        def self.reduce_for_lattice_products json, cols
          result = []

          unless json.nil? || json["product"]["variants"].empty?
            json["product"]["variants"][0]["variant"]["store_variants"].each do |sv|
              store_variant = sv["store_variant"]
              result << {
                store_name: store_variant["store_name"],
                qty: store_variant["qty"],
                inventory_qty: store_variant["inventory_qty"],
                sell_price: store_variant["sell_price"]["money"]["cents"],
                buy_price: store_variant["buy_price"]["money"]["cents"]
              } 
            end
          end

          result
        end

        def self.reduce_for_lattice_stores json, cols
          result = []

          unless json.nil?
            json.each do |s|
              store = s["store"]
              result << {
                name: store["name"],
                postal_code: store["postal_code"] || "",
                url: store["url"] || ""
              } 
            end
          end

          result
        end

        def self.reduce_for_lattice_offers json, cols
          result = []

          unless json.nil? || json.empty?
            offers = json.first.last
            offers.each do |offer|
              result << {
                name: offer["store"]["database_name"],
                buy_price: offer["buy_price"]["cents"],
                store_credit_buy_price: offer["store_credit_buy_price"]["cents"],
                qty: offer["url"] || "",
                web_qty: offer["web_qty"] || "",
              } 
            end
          end

          result
        end

        def self.reduce_for_catalog_products json, cols
          result = []

          unless json.nil? || json.empty?
            json["products"].each do |p|
              result << {
                name: p["name"],
                seoname: p["seoname"],
                category_name: p["category_name"],
                weight: p["weight"],
                description: p["description"]
              } 
            end
          end

          result
        end

        def self.reduce_for_catalog_product_types json, cols
          result = []

          unless json.nil? || json["product_types"].empty?
            json["product_types"].each do |p|
              result << {
                name: p["name"],
                default_weight: p["default_weight"],
                amazon_search_index: p["amazon_search_index"] || "",
                weight: p["weight"] || "",
              } 
            end
          end

          result
        end

        def self.reduce_for_catalog_stores json, cols
          result = []

          unless json.nil? || json["stores"].empty?
            json["stores"].each do |store|
              result << {
                name: store["name"],
                address1: store["address1"],
                address2: store["address2"],
                postal_code: store["postal_code"],
                city: store["city"],
                state: store["state"],
                country: store["country"]
                #url: store["url"]
                #latitude: store["latitude"],
                #longitude: store["longitude"]
              } 
            end
          end

          result
        end

        def self.reduce_for_catalog_categories json, cols
          result = []

          unless json.nil? || json["categories"].empty?
            json["categories"].each do |store|
              result << {
                name: store["name"],
                seoname: store["seoname"],
                description: store["description"],
                available_on: store["available_on"] || "",
                set_code: store["set_code"],
                product_type_id: store["product_type_id"] || ""
              } 
            end
          end

          result
        end

        def self.reduce_for_store_products json, cols
          result = []

          unless json.nil? || json["paginated_collection"].empty? || json["paginated_collection"]["entries"].empty?
            json["paginated_collection"]["entries"].each do |store|
              result << {
                name: store["product"]["name"],
                seoname: store["product"]["seoname"],
                description: store["product"]["description"]
              } 
            end
          end

          result
        end
      end
    end
  end
end


