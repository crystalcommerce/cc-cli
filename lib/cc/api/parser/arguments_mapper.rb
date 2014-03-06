module Cc
  module Api
    module Parser

      #TODO Dry this up
      class ArgumentsMapper
        # cc lattice-products OPTIONS [COLUMNS]

        # arguments + descrption
        ARGUMENTS = {
          "--id" => "The id of the product",
          "--sku" => "sku of the product"
        }

        POSSIBILITY_REGEXES = {
          "lattice-products" => [/^--id\s[0-9]*\s--skus\s[0-9a-z(,)*]*$/, /^--skus\s[0-9a-z]*\s--id\s[0-9(,)*]*$/],
          "lattice-stores" => [/^$/],
          "lattice-offers" => [/^--id\s[0-9]*\s--skus\s[0-9a-z(,)*]*$/, /^--skus\s[0-9a-z]*\s--id\s[0-9(,)*]*$/],
          "catalog-products" => [/^$/],
          "catalog-product_types" => [/^$/],
          "catalog-stores" => [/^$/]
        }

        ACTIONS = {
          "lattice-products" => {:url => "http://lattice.crystalcommerce.com/api/v1/products"},
          "lattice-stores" => {:url => "http://lattice.crystalcommerce.com/api/v1/stores"},
          "lattice-offers" => {:url => "http://lattice.crystalcommerce.com/api/v1/offers", :method => "POST"},
          "catalog-products" => {:url => "https://catalog.crystalcommerce.com/api/v1/products"},
          "catalog-product_types" => {:url => "https://catalog.crystalcommerce.com/api/v1/product_types"},
          "catalog-stores" => {:url => "https://catalog.crystalcommerce.com/api/v1/stores"}
        }

        def self.map args
          case args[0]
          when "lattice-products"
            match = self.match args
            case match
            when 0
              return {:id => args[2], :skus => args[4].to_s.split(',')} 
            when 1
              return {:id => args[4], :skus => args[2].to_s.split(',')} 
            else 
              return nil
            end
          when "lattice-stores"
            match = self.match args 
            case match
            when 0
              return {}
            else
              return nil
            end
          when "lattice-offers"
            match = self.match args
            case match
            when 0
              return {:id => args[2], :skus => args[4].to_s.split(',')} 
            when 1
              return {:id => args[4], :skus => args[2].to_s.split(',')} 
            else 
              return nil
            end
          when "catalog-products"
            match = self.match args 
            case match
            when 0
              return {}
            else
              return nil
            end
          when "catalog-product_types"
            match = self.match args 
            case match
            when 0
              return {}
            else
              return nil
            end
          when "catalog-stores"
            match = self.match args 
            case match
            when 0
              return {}
            else
              return nil
            end
          else
            return nil
          end

        end

        protected

        def self.match args
          POSSIBILITY_REGEXES[args[0]].each_with_index do |regex, index|
            return index if args[1..4].join(' ').match regex
          end

          nil
        end
      end
    end
  end
end
