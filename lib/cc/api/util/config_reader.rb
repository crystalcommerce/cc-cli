module Cc
  module Api
    module Util
      class LicenseKeysException < Exception 
      end

      class ConfigReader
        def self.license
          begin
            keys = YAML.load_file(self.path)['license']
            self.raise_license_key_exception if keys['ssologin'].nil? || keys['key'].nil?
            keys
          rescue 
            self.raise_license_key_exception
          end
        end

        protected

        def self.raise_license_key_exception
          raise LicenseKeysException, 'License keys not set properly. Please run "cc init to generate config/cc_api_keys.yml" to place your keys'
        end

        def self.path
          File.join(File.dirname(__FILE__), '..', '..', '..', 'config', 'cc_api_keys.yml')
        end    
      end
    end
  end
end

