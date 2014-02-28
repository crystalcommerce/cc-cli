require 'cc/api/explorer/version'
require 'thor'
require 'command_line_reporter'

module Cc
  module Api
    module Explorer
      class Products < Thor
        include CommandLineReporter

        #desc "products --id ID", "Returns <Store Name | Qty | Sell Price | Buy Price>"
        desc "products", "Returns <Store Name | Qty | Sell Price | Buy Price>"

        def products *args
          #put lattice product call instead of catalog
          response = HTTParty.get('https://catalog.crystalcommerce.com/api/v1/products')
          table :border => true do
            row do
              column('name', align: 'left', width: 30, padding: 5)
              column('seoname', align: 'left', width: 30, padding: 5)
              column('category_name', align: 'left', width: 30, padding: 5)
            end

            response['products'].each do |product|  
              row do
                column(product['name'])
                column(product['seoname'])
                column(product['category_name'])
              end
            end
          end
        end
      end
    end
  end
end
