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
        include CommandLineReporter

        desc "latticeproducts --id ID --sku SKU", "returns <storename | qty | inventory_qty | sell_price | buy_price> for a particular sku of a product"
        def latticeproducts *args
          action = "lattice-products"
          args.unshift action

          begin
            param = Cc::Api::Parser::ArgumentsParser.parse args
            response = Cc::Api::Http::HttpRequestor.request_for_json param 

            result = Cc::Api::Parser::JsonParser.reduce action, response[:body], []

            puts "GET" 
            puts "#{param[:request]}"
            puts "response time: #{response[:response_time]}"

            tabler = Cc::Api::Presentor::Tabler.new
            tabler.present result
          #rescue Cc::Api::Parser::CLIArgumentsException
          #  puts "PUT ERROR HERE"
          #rescue 
          #  puts "PUT ERROR HERE AS WELL"
          end
        end
      end
    end
  end
end
