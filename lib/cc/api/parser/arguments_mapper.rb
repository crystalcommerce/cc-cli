require 'cc/api/util/config_reader'

module Cc
  module Api
    module Parser
      class ArgumentsMapper
        ACTIONS = {
          "lattice-products" => {:url => "https://api.crystalcommerce.com/v1/lattice/products"},
          "lattice-stores" => {:url => "https://api.crystalcommerce.com/v1/lattice/stores"},
          "lattice-offers" => {:url => "https://api.crystalcommerce.com/v1/lattice/offers", :method => "POST"},
          "catalog-products" => {:url => "https://api.crystalcommerce.com/v1/catalog/products"},
          "catalog-product_types" => {:url => "https://api.crystalcommerce.com/v1/catalog/product_types"},
          "catalog-stores" => {:url => "https://api.crystalcommerce.com/v1/catalog/stores"},
          "catalog-categories" => {:url => "https://api.crystalcommerce.com/v1/catalog/categories"},
          "store-products" => {:url => "https://*-api.crystalcommerce.com/v1/products"}
        }

        def self.map args
          return args[:params] || {}
        end
      end
    end
  end
end
