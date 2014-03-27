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
      
        option :json, :type => :boolean, :banner => "Prints the JSON format response body instead"
        option :id
        option :skus
        desc "lattice [products --id <PRODUCT ID> --skus <PRODUCT SKUS separated by ','>] | [offers --id <PRODUCT ID> --skus <PRODUCT SKUS separated by ','>] | [stores]", 
              "The Market Data APIs track the Prices, Quantities, and similar data. It also indicates which stores in the CrystalCommerce in-network currently has those products for sale."
        def lattice subcommand
          case subcommand 
          when "products"
            args = {:action => "lattice-products", :params => {:id => options[:id], :skus => options[:skus].to_s.split(',') } }
            self.perform args
          when "stores"
            args = {:action => "lattice-stores"}
            self.perform args
          when "offers"
            args = {:action => "lattice-offers", :params => {:id => options[:id], :skus => options[:skus].to_s.split(',') } }
            self.perform args
          else
            Cc::Api::Parser::ArgumentsParser.raise_cli_arguments_exception
          end
        end

        option :json, :type => :boolean, :banner => "Prints the JSON format response body instead"
        option :page, :type => :numeric
        desc "catalog [products] | [product_types] | [stores] | [categories]", "This API will give access to read and write to the catalog of products. This includes what products could be sold but doesn't include prices or quantities, which are stored in the Market Data APIs."
        def catalog subcommand
          case subcommand 
          when "products"
            args = {:action => "catalog-products", :params => { :page => options[:page] || 1 } }
            self.perform args
          when "product_types"
            args = {:action => "catalog-product_types", :params => { :page => options[:page] || 1 } }
            self.perform args
          when "stores"
            args = {:action => "catalog-stores"}
            self.perform args
          when "categories"
            args = {:action => "catalog-categories", :params => { :page => options[:page] || 1} }
            self.perform args
          else
            Cc::Api::Parser::ArgumentsParser.raise_cli_arguments_exception
          end
        end
        
        option :json, :type => :boolean, :banner => "Prints the JSON format response body instead"
        option :token
        option :store
        desc "store [products --token <access token> --store <store name>]", "The Store Data API provides access to the data related to a single store whereas the Market Data API applies to all stores."
        def storeproducts subcommand
          case subcommand
          when "products"
            args = {:action => "store-products", :params => {:token => options[:token], :store => options[:store] } }
            self.perform args
          else
            Cc::Api::Parser::ArgumentsParser.raise_cli_arguments_exception
          end
        end

        protected

        def perform args
          action = args[:action]
          begin
            param = Cc::Api::Parser::ArgumentsParser.parse args
            response = Cc::Api::Http::HttpRequestor.request_for_json param 
            puts "response time: #{response[:response_time]}"
            unless options[:json]
              @result = Cc::Api::Parser::JsonParser.reduce action, response[:body], []
              tabler = Cc::Api::Presentor::Tabler.new
              tabler.present @result
            else
              puts JSON.pretty_generate response[:body]
            end
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
