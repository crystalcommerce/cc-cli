require 'cc/api/parser/arguments_mapper'

#TODO: Dry this up!
module Cc
  module Api
    module Parser
      class CLIArgumentsException < Exception 
      end

      class ArgumentsParser
        def self.parse args
          unless Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first].nil?
            if res = Cc::Api::Parser::ArgumentsMapper.map(args)
              self.build_action_url args, res 
            else
              raise CLIArgumentsException
            end
          else
            raise CLIArgumentsException
          end
        end

        protected

        def self.build_action_url args, res
          case args.first
          when "lattice-products"
            #TODO fix this
            { :request => { url: Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first][:url] + "/#{res[:id]}?" + res[:skus].collect{|x| "skus[]=#{x}" }.join('&') } }
          when "lattice-stores"
            { :request => Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first]  }
          when "lattice-offers"
            { :request => { 
                url: Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first][:url],
                body: {"search" => {"skus" => {"#{res[:id]}" => res[:skus].collect{|x| x.to_s }}}},
                method: Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first][:method]
              } 
            }
            #{ :request => Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first]  }
          when "catalog-products"
            { :request => Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first]  }
          when "catalog-product_types"
            { :request => Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first]  }
          when "catalog-stores"
            { :request => Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first]  }
          when "catalog-categories"
            { :request => Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first]  }
          when "store-products"
            { :request => { url: Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first][:url].sub('*', res[:store]), token: res[:token] } }
          else
            nil
          end
        end
      end
    end
  end
end
