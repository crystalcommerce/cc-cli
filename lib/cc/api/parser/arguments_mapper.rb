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

        POSSIBILITY_REGEXES = [
          /^--id\s[0-9]*\s--skus\s[0-9a-z(,)*]*$/,
          /^--skus\s[0-9a-z]*\s--id\s[0-9(,)*]*$/
        ]

        ACTIONS = {
          "lattice-products" => "http://lattice.crystalcommerce.com/api/v1/products"
          #"lattice-products" => "https://api.crystalcommerce.com/v1/lattice/products"
        }

        def self.map args
          match = self.match args
          case match
          when 0
            return {:id => args[2], :skus => args[4].to_s.split(',')} 
          when 1
            return {:id => args[4], :skus => args[2].to_s.split(',')} 
          else 
            return nil
          end
        end

        protected

        def self.match args
          POSSIBILITY_REGEXES.each_with_index do |regex, index|
            return index if args[1..4].join(' ').match regex
          end

          nil
        end
      end
    end
  end
end
