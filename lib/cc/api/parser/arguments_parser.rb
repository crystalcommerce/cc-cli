require 'cc/api/parser/arguments_mapper'

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
            { :request => Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first] + "/#{res[:id]}?" + res[:skus].collect{|x| "skus[]=#{x}" }.join('&') }
          when "lattice-stores"
            { :request => Cc::Api::Parser::ArgumentsMapper::ACTIONS[args.first]  }
          else
            nil
          end
        end
      end
    end
  end
end
