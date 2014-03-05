module Cc
  module Api
    module Parser

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
          "catalog-products" => [/^$/]
        }

        ACTIONS = {
          "lattice-products" => "http://lattice.crystalcommerce.com/api/v1/products",
          "lattice-stores" => "http://lattice.crystalcommerce.com/api/v1/stores",
          "catalog-products" => "https://catalog.crystalcommerce.com/api/v1/products"
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
          when "catalog-products"
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
