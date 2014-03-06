require 'cc/api/explorer/version'
require 'cc/api/http/http_requestor'
require 'cc/api/parser/arguments_parser'
require 'cc/api/parser/json_parser'
require 'cc/api/presentor/presentor'
require 'command_line_reporter'
require 'thor'

module Cc
  module Api
    module Explorer
      class CLI < Thor

        desc "latticeproducts --id ID --sku SKU", "returns <storename | qty | inventory_qty | sell_price | buy_price> for a particular sku of a product"
        def latticeproducts *args
          args.unshift "lattice-products"
          self.perform args
        end

        desc "latticestores", "returns <name | postal_code | url>"
        def latticestores *args
          args.unshift "lattice-stores"
          self.perform args
        end

        desc "latticestores", "returns <*>"
        def latticeoffers *args
          args.unshift "lattice-offers"
          self.perform args
        end

        desc "catalogproducts", "returns <*>"
        def catalogproducts *args
          args.unshift "catalog-products"
          self.perform args
        end

        protected

        def perform args
          action = args.first
          begin
            param = Cc::Api::Parser::ArgumentsParser.parse args
            response = Cc::Api::Http::HttpRequestor.request_for_json param 

            result = Cc::Api::Parser::JsonParser.reduce action, response[:body], []

            puts "GET" 
            puts "#{param[:request]}"
            puts "response time: #{response[:response_time]}"

            tabler = Cc::Api::Presentor::Tabler.new
            tabler.present result
            #puts "Command not found. Please run 'cc' to print all the available commands"
          rescue Cc::Api::Parser::CLIArgumentsException
            puts "Error. Please run 'cc' for a list of available commands and their corresponding usage"
          end
        end
      end
    end
  end
end
