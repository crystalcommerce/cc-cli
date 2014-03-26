require 'cc/api/explorer/version'
require 'cc/api/http/http_requestor'
require 'cc/api/parser/arguments_parser'
require 'cc/api/parser/json_parser'
require 'cc/api/presentor/presentor'
require 'cc/api/util/config_reader'
require 'command_line_reporter'
require 'thor'
require 'yaml'

module Cc
  module Api
    module Explorer
      class CLI < Thor
      
        option :id
        option :skus
        desc "lattice [products --id <PRODUCT ID> --skus <PRODUCT SKUS separated by ','>] | [offers --id <PRODUCT ID> --skus <PRODUCT SKUS separated by ','>] | [stores]", 
              "The Market Data APIs track the Prices, Quantities, and similar data. It also indicates which stores in the CrystalCommerce in-network currently has those products for sale."
        def lattice subcommand
          case subcommand 
          when "products"
            self.perform ["lattice-products", "--id", options[:id], "--skus", options[:skus]]
          when "stores"
            self.perform ["lattice-stores"]
          when "offers"
            self.perform ["lattice-offers", "--id", options[:id], "--skus", options[:skus]]
          else
            Cc::Api::Parser::ArgumentsParser.raise_cli_arguments_exception
          end
        end

        desc "catalog [products] | [product_types] | [stores] | [categories]", "This API will give access to read and write to the catalog of products. This includes what products could be sold but doesn't include prices or quantities, which are stored in the Market Data APIs."
        def catalog subcommand
          case subcommand 
          when "products"
            self.perform ["catalog-products"]
          when "product_types"
            self.perform ["catalog-product_types"]
          when "stores"
            self.perform ["catalog-stores"]
          when "categories"
            self.perform ["catalog-categories"]
          else
            Cc::Api::Parser::ArgumentsParser.raise_cli_arguments_exception
          end
        end
        
        option :token
        option :store
        desc "store [products --token <access token> --store <store name>]", "The Store Data API provides access to the data related to a single store whereas the Market Data API applies to all stores."
        def storeproducts subcommand
          case subcommand
          when "products"
            args = ["store-products", "--token", options[:token], "--store", options[:store]]
            self.perform args
          else
            Cc::Api::Parser::ArgumentsParser.raise_cli_arguments_exception
          end
        end

        protected

        def perform args
          action = args.first
          begin
            param = Cc::Api::Parser::ArgumentsParser.parse args
            response = Cc::Api::Http::HttpRequestor.request_for_json param 

            @result = Cc::Api::Parser::JsonParser.reduce action, response[:body], []

            puts "response time: #{response[:response_time]}"

            tabler = Cc::Api::Presentor::Tabler.new
            tabler.present @result
          rescue Cc::Api::Util::LicenseKeysException
            puts 'License keys not set properly. Place your keys at ~/.bashrc (linux) or ~/.profile (mac). Just add this line "export CC_API_KEYS=<ssologin>:<key>"'
          rescue Cc::Api::Http::ServerProblemException
            puts "There's a problem with the server. Server response not expected."
          end
        end
      end
    end
  end
end
