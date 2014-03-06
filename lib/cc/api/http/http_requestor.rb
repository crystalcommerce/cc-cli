require 'httparty'

module Cc
  module Api
    module Http
      class HttpRequestor
        def self.request_for_json params
          start_time = Time.now
          if params[:request][:method] == "POST"
            response_body = HTTParty.post(
                params[:request][:url],
                :body => params[:request][:body].to_json,
                :headers => { 'Content-Type' => 'application/json' }
            )
          else
            response_body = HTTParty.get(params[:request][:url])
          end
          end_time = Time.now
          return {body: response_body, response_time: end_time - start_time}
        end
      end 
    end
  end
end

