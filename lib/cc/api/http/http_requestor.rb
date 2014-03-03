module Cc
  module Api
    module Http
      class HttpRequestor
        def self.request_for_json 
          response = HTTParty.get('https://catalog.crystalcommerce.com/api/v1/products')
        end
      end 
    end
  end
end

