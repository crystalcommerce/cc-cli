require 'cc/api/util/config_reader'

module Cc
  module Api
    module Parser
      class ArgumentsMapper
        def self.map args
          return args[:params] || {}
        end

        def self.get_url action
          keys = action.split '-'
          yaml = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'config.yml')))
          keys.each do |key|
            yaml = yaml[key]
          end
          Hash[yaml.map{ |k, v| [k.to_sym, v] }]
        end

        def self.get_target_key_chain action
          keys = action.split '-'
          yaml = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'config.yml')))
          keys.each do |key|
            yaml = yaml[key]
          end
          Hash[yaml.map{ |k, v| [k.to_sym, v] }][:target_key_chain]
        end
      end
    end
  end
end
