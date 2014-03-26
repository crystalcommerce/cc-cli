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
            raise Cc::Api::Parser::CLIArgumentsException
          end
        end

        desc "catalogproducts", "returns < name | seoname | category_name | weight | description >"
        def catalogproducts
          args.unshift "catalog-products"
          self.perform args
        end

        desc "catalogproducttypes", "returns < name | default_weight | amazon_search_index | weight >"
        def catalogproducttypes
          args.unshift "catalog-product_types"
          self.perform args
        end

        desc "catalogstores", "returns < name | address1 | address2 | postal_code | city | state | country >"
        def catalogstores
          args.unshift "catalog-stores"
          self.perform args
        end

        desc "catalogcategories", "returns < name | seoname | description | available_on | set_code | product_type_id >"
        def catalogcategories
          args.unshift "catalog-categories"
          self.perform args
        end

        option :token
        option :store
        desc "storeproducts --token <access token> --store <store name>", "returns < name | seoname | description >"
        def storeproducts
          args = ["store-products", "--token", options[:token], "--store", options[:store]]
          self.perform args
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
          rescue Cc::Api::Parser::CLIArgumentsException
            puts Cc::Api::Parser::ArgumentsParser::ERRORS['cli_arguments_exception']
          end
        end
      end
    end
  end
end
