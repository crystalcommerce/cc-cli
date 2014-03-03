module Cc
  module Api
    module Parser
      class JsonParser
        def self.reduce action, json, cols
          case action
          when "lattice-products"
            self.reduce_for_lattice_products json, cols  
          else
            nil
          end
        end

        protected

        def self.reduce_for_lattice_products json, cols
          result = []
          #TODO: verify this
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

          result
        end
      end
    end
  end
end


