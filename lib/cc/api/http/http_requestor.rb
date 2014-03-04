require 'httparty'

module Cc
  module Api
    module Http
      class HttpRequestor
        def self.request_for_json params
          start_time = Time.now
          response_body = HTTParty.get(params[:request])
          end_time = Time.now
          return {body: response_body, response_time: end_time - start_time}
        end
      end 
    end
  end
end

