require 'cc/api/parser/arguments_mapper'

module Cc
  module Api
    module Parser
      class CLIArgumentsException < StandardError
      end

      class ArgumentsParser
        ERRORS = {
          'cli_arguments_exception' => "Error. Please run 'cc-cli' for a list "\
            "of available commands and their corresponding usage"
        }

        def self.parse(args)
          unless Cc::Api::Parser::ArgumentsMapper::get_url(args[:action]).nil?
            if res = Cc::Api::Parser::ArgumentsMapper.map(args)
              self.build_action_url args, res
            else
              self.raise_cli_arguments_exception
            end
          else
            self.raise_cli_arguments_exception
          end
        end

        def self.raise_cli_arguments_exception
          begin
            raise CLIArgumentsException.new(ERRORS['cli_arguments_exception'])
          rescue Exception => e
            puts e.message
          end
        end

        private

        def self.build_action_url(args, res)
          action = Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])

          case args[:action]
          when "market_data-products"
            url = action[:url]
            query = res[:skus].map{|x| "skus[]=#{x}" }.join('&')
            {
              request: {
                url: "#{url}/#{res[:id]}?#{query}"
              }
            }
          when "market_data-stores", "catalog-stores"
            {
              request: action
            }
          when "market_data-offers"
            {
              request: {
                url: action[:url],
                method: action[:method],
                body: {
                  "search" => {
                    "skus" => {
                      "#{res[:id]}" => res[:skus].map(&:to_s)
                    }
                  }
                }
              }
            }
          when "catalog-products", "catalog-product_types", "catalog-categories"
            {
              request: {
                url: action[:url] + "?page=#{res[:page]}"
              }
            }
          when "store-products"
            {
              request: {
                url: action[:url].sub(':db', res[:store]) + "?page=#{res[:page]}"
              }
            }
          else
            nil
          end
        end
      end
    end
  end
end
