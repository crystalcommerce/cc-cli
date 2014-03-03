require 'cc/api/explorer/version'
require 'thor'
require 'command_line_reporter'
require 'cc/api/http/http_requestor'
require 'cc/api/parser/arguments_parser'
require 'cc/api/parser/json_parser'

module Cc
  module Api
    module Explorer
      class CLI < Thor
        desc "latticeproducts", "Returns <Store Name | Qty | Sell Price | Buy Price>"
        def latticeproducts *args
          action = "lattice-products"
          args.unshift action

          begin
            param = Cc::Api::Parser::ArgumentsParser.parse args
            response = Cc::Api::Http::HttpRequestor.request_for_json param 
            result = Cc::Api::Parser::JsonParser.reduce action, response, []
          rescue Cc::Api::Parser::CLIArgumentsException
            puts "PUT ERROR HERE"
          rescue 
            puts "ERRR"
          end
        end
      end
    end
  end
end
