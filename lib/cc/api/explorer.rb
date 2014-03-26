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
        attr_reader :result
      
        option :id
        option :skus
        desc "latticeproducts --id ID --skus <array of skus separated by ','>", "returns < storename | qty | inventory_qty | sell_price | buy_price >"
        def latticeproducts
          args = ["lattice-products", "--id", options[:id], "--skus", options[:skus]]
          self.perform args
        end

        desc "latticestores", "returns < name | postal_code | url >"
        def latticestores 
          args.unshift "lattice-stores"
          self.perform args
        end

        option :id
        option :skus
        desc "latticeoffers --id ID --skus <array of skus separated by ','>", "returns < name | postal_code | url >"
        def latticeoffers
          args = ["lattice-offers", "--id", options[:id], "--skus", options[:skus]]
          self.perform args
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
            #puts "Command not found. Please run 'cc' to print all the available commands"
          rescue Cc::Api::Util::LicenseKeysException
            puts 'License keys not set properly. Place your keys at ~/.bashrc (linux) or ~/.profile (mac). Just add this line "export CC_API_KEYS=<ssologin>:<key>"'
          rescue Cc::Api::Http::ServerProblemException
            puts "There's a problem with the server. Server response not expected."
          rescue Cc::Api::Parser::CLIArgumentsException
            puts "Error. Please run 'cc' for a list of available commands and their corresponding usage"
          end
        end
      end
    end
  end
end
