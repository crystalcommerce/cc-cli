require 'cc/api/parser/arguments_mapper'

module Cc
  module Api
    module Parser
      class CLIArgumentsException < StandardError
      end

      class ArgumentsParser
        ERRORS = {'cli_arguments_exception' => "Error. Please run 'cc' for a list of available commands and their corresponding usage"}

        def self.parse args
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

        def self.build_action_url args, res
          case args[:action]
          when "lattice-products"
            #TODO fix this
            { :request => { url: Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])[:url] + "/#{res[:id]}?" + res[:skus].collect{|x| "skus[]=#{x}" }.join('&') } }
          when "lattice-stores"
            { :request => Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])  }
          when "lattice-offers"
            { :request => { 
                url: Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])[:url],
                body: {"search" => {"skus" => {"#{res[:id]}" => res[:skus].collect{|x| x.to_s }}}},
                method: Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])[:method]
              } 
            }
          when "catalog-products"
            { :request => { :url => Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])[:url] + "?page=#{res[:page]}"  } }
          when "catalog-product_types"
            { :request => { :url => Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])[:url] + "?page=#{res[:page]}" } }
          when "catalog-stores"
            { :request => Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])  }
          when "catalog-categories"
            { :request => { :url => Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])[:url] + "?page=#{res[:page]}" } }
          when "store-products"
            { :request => { url: Cc::Api::Parser::ArgumentsMapper::get_url(args[:action])[:url].sub('*', res[:store]) + "?page=#{res[:page]}", token: res[:token] } }
          else
            nil
          end
        end
      end
    end
  end
end
