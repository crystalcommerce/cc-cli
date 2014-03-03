require 'command_line_reporter'

module Cc
  module Api
    module Explorer
      class Presentor
        include CommandLineReporter

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

