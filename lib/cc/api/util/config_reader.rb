module Cc
  module Api
    module Util
      class LicenseKeysException < Exception 
      end

      class ConfigReader

        def self.license
          begin
            self.parse_keys self.get_keys
          rescue 
            self.raise_license_key_exception
          end
        end

        protected

        def self.get_keys
          ENV['CC_API_KEY']
        end

        def self.parse_keys key
          raise self.raise_license_key_exception unless key.match /^[a-z]*:[0-9a-zA-Z]*$/
          pair = key.split(':')
          {:username => pair[0], :password => pair[1]}
        end

        def self.raise_license_key_exception
          raise LicenseKeysException, 'License keys not set properly. Place your keys at ~/.bashrc (linux) or ~/.profile (mac). Just add this line "export CC_API_KEYS=<ssologin>:<key>"' 
        end

        def self.path
          File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'cc_api_keys.yml')
        end    
      end
    end
  end
end

