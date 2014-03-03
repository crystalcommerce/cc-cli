module Cc
  module Api
    module Http
      class HttpRequestor
        def self.request_for_json params
          HTTParty.get(params[:request])
        end
      end 
    end
  end
end

