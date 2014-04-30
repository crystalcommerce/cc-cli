require 'httparty'

module Cc
  module Api
    module Http
      class ServerProblemException < StandardError
      end

      class UnauthorizedAccessException < StandardError
      end

      class HttpRequestor
        def request_for_json(params)
          start_time = Time.now

          log_request_action(params[:request])

          if params[:request][:method] == "POST"
            response_body = HTTParty.post(
                params[:request][:url],
                :basic_auth => basic_auth,
                :body => params[:request][:body].to_json,
                :headers => { 'Content-Type' => 'application/json' }
            )
          else
            response_body = HTTParty.get(params[:request][:url],
                                         :basic_auth => basic_auth)
          end

          end_time = Time.now

          if response_body.code == 401
            raise UnauthorizedAccessException,
              "You don't have enough privilege to access." 
          end

          if response_body.code == 500
            raise ServerProblemException,
              "There's a problem with the server. Server response not expected." 
          end

          return {body: response_body, response_time: end_time - start_time}
        end

      private

        def basic_auth
          @basic_auth ||= {
                           :username => license.username,
                           :password => license.password
                          }
        end

        def license
          @license ||= Cc::Api::Util::ConfigReader.license
        end

        def log_request_action(request)
          puts "#{request[:method] || "GET"} #{request[:url]} #{request[:body]}"
        end
      end
    end
  end
end
