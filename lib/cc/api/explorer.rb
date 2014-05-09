require 'cc/api/explorer/version'
require 'cc/api/http/http_requestor'
require 'cc/api/parser/arguments_parser'
require 'cc/api/parser/json_parser'
require 'cc/api/presentor/presentor'
require 'cc/api/util/config_reader'
require 'cc/api/util/key_chains_getter'
require 'command_line_reporter'
require 'thor'
require 'yaml'
require 'cc/api/util/credential_writer'

module Cc
  module Api
    module Explorer
      class CLI < Thor
        DEFAULT_COLS =
          {
            "market_data-products" => ["store_variant.store_name",
                                       "store_variant.qty",
                                       "store_variant.buy_price.money.currency"],
            "market_data-stores" => ["store.name",
                                     "store.state",
                                     "store.url"],
            "market_data-offers" => ["store.name",
                                     "buy_price.cents",
                                     "sell_price.cents"],
            "catalog-products" => ["name",
                                   "barcode",
                                   "weight"],
            "catalog-product_types" => ["name",
                                        "id",
                                        "default_weight"],
            "catalog-stores" => ["name",
                                 "postal_code",
                                 "url"],
            "catalog-categories" => ["name",
                                     "seoname",
                                     "description"],
            "store-products" => ["product.seoname",
                                 "product.weight",
                                 "product.description"]
          }

        DESC =
          {
            "cols" => "Columns to display to the output table. To determine "\
                      "the 'available columns' for a selected command "\
                      "use --available_cols",
            "available_cols" => "Output the available columns for output for "\
                                "a command",
            "offset" => "Offset of the starting row to be displayed. Nothing "\
                        "is displayed when out of bounds",
            "limit" => "Limit of rows to be displayed",
            "colw" => "Width of every column to be displayed",
            "colp" => "Padding of every cell to be displayed",
            "json" => "Prints the JSON response body instead",
            "id" => "Product ID",
            "skus" => "SKUs separated by ',' if more than one",
            "page" => "Page number of the response",
            "store" => "Store name (CrystalCommerce Client)",
            "csv" => "Print out the result into a csv file. Columns are "\
                     "separated by comma"
          }


        option :csv, :desc => DESC["csv"], :banner => "CSV_FILE_PATH"
        option :cols, :desc => DESC["cols"]
        option :available_cols, :type => :boolean, :desc => DESC["available_cols"]
        option :offset, :type => :numeric, :desc => DESC["offset"]
        option :limit, :type => :numeric, :desc => DESC["limit"]
        option :colw, :type => :numeric, :desc => DESC["colw"]
        option :colp, :type => :numeric, :desc => DESC["colp"]
        option :json, :type => :boolean, :desc => DESC["json"]
        option :id, :desc => DESC["id"]
        option :skus, :desc => DESC["skus"]
        desc "market_data [products --id <PRODUCT ID> "\
             "--skus <PRODUCT SKUS separated by ','>] |"\
             "[offers --id <PRODUCT ID> "\
             "--skus <PRODUCT SKUS separated by comma>] | [stores]",
             "The Market Data APIs track the Prices, Quantities, and similar "\
             "data. It also indicates which stores in the CrystalCommerce "\
             "in-network currently has those products for sale."
        def market_data(subcommand)
          case subcommand
          when "products"
            args = {
              :action => "market_data-products",
              :params => {
                :id => options[:id],
                :skus => options[:skus].to_s.split(',')
              }
            }
            perform(args)
          when "stores"
            args = {:action => "market_data-stores"}
            perform(args)
          when "offers"
            args = {
              :action => "market_data-offers",
              :params => {
                :id => options[:id],
                :skus => options[:skus].to_s.split(',')
              }
            }
            perform(args)
          else
            Cc::Api::Parser::ArgumentsParser.raise_cli_arguments_exception
          end
        end

        option :csv, :desc => DESC["csv"], :banner => "CSV_FILE_PATH"
        option :cols, :desc => DESC["cols"]
        option :available_cols, :type => :boolean, :desc => DESC["available_cols"]
        option :offset, :type => :numeric, :desc => DESC["offset"]
        option :limit, :type => :numeric, :desc => DESC["limit"]
        option :colw, :type => :numeric, :desc => DESC["colw"]
        option :colp, :type => :numeric, :desc => DESC["colp"]
        option :json, :type => :boolean, :desc => DESC["json"]
        option :page, :type => :numeric, :desc => DESC["page"]

        desc "catalog [products] | [product_types] | [stores] | [categories]",
          "This API will give access to read the catalog of products. This "\
          "includes what products could be sold but doesn't include prices "\
          "or quantities, which are stored in the Market Data APIs."
        def catalog(subcommand)
          case subcommand
          when "products"
            args = {
              :action => "catalog-products",
              :params => {
                :page => options[:page] || 1
              }
            }
            perform(args)
          when "product_types"
            args = {
              :action => "catalog-product_types",
              :params => {
                :page => options[:page] || 1
              }
            }
            perform(args)
          when "stores"
            args = {:action => "catalog-stores"}
            perform(args)
          when "categories"
            args = {
              :action => "catalog-categories",
              :params => {
                :page => options[:page] || 1
              }
            }
            perform(args)
          else
            Cc::Api::Parser::ArgumentsParser.raise_cli_arguments_exception
          end
        end

        option :csv, :desc => DESC["csv"], :banner => "CSV_FILE_PATH"
        option :cols, :desc => DESC["cols"]
        option :available_cols, :type => :boolean, :desc => DESC["available_cols"]
        option :offset, :type => :numeric, :desc => DESC["offset"]
        option :limit, :type => :numeric, :desc => DESC["limit"]
        option :colw, :type => :numeric, :desc => DESC["colw"]
        option :colp, :type => :numeric, :desc => DESC["colp"]
        option :json, :type => :boolean, :desc => DESC["json"]
        option :page, :type => :numeric, :desc => DESC["page"]
        option :store, :desc => DESC["store"]

        desc "store [products --store <store name>]"\
            "\n\n For more detailed instructions please visit "\
            "https://github.com/crystalcommerce/cc-cli#readme",
          "The Store Data API provides access to the data related to a "\
          "single store whereas the Market Data API applies to all stores."
        def store(subcommand)
          case subcommand
          when "products"
            args = {
              :action => "store-products",
              :params => {
                :store => options[:store],
                :page => options[:page] || 1
              }
            }
            perform(args)
          else
            Cc::Api::Parser::ArgumentsParser.raise_cli_arguments_exception
          end
        end

        private

        def perform(args)

          action = args[:action]

          begin
            param = Cc::Api::Parser::ArgumentsParser.parse args
            response = http_requestor.request_for_json param

            if options[:json]
              puts JSON.pretty_generate response[:body]
            else
              target = Cc::Api::Parser::ArgumentsMapper.get_target_key_chain(action)
              array = Cc::Api::Util::KeyChainsGetter.get_target_array(response[:body], target, options[:id])
              if options[:available_cols]
                ignores = Cc::Api::Parser::ArgumentsMapper.get_ignored_key_chain(action)
                Cc::Api::Util::KeyChainsGetter.get_key_chains(array.first,
                                                              "",
                                                              ignores)
              else
                puts "response time: %.3fs" % response[:response_time]
                begin
                  result = Cc::Api::Parser::JsonParser.vanilla_reduce(array, options[:cols].split(','))
                rescue
                  result = Cc::Api::Parser::JsonParser.vanilla_reduce(array, DEFAULT_COLS[action])
                end
                tabler = Cc::Api::Presentor::Tabler.new
                tabler.present(result,
                               options[:colw],
                               options[:colp],
                               options[:offset],
                               options[:limit])
                if options[:csv]
                  Cc::Api::Presentor::CSVer.to_csv(result,
                                                   options[:csv],
                                                   options[:offset],
                                                   options[:limit])
                end
              end
            end
          rescue => e
            puts e.message
          end
        end

        def http_requestor
          Cc::Api::Http::HttpRequestor.new
        end
      end
    end
  end
end
