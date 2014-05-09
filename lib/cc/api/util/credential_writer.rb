require 'pry'
module Cc
  module Api
    module Util
      class CredentialWriter

        def self.setup
          shell = Thor::Shell::Basic.new
          shell.say("License key not set propery. Please enter your username and license key below.")
          username = shell.ask("Username:")
          license_key = shell.ask("License Key:")
          write(username, license_key)
          get_keys
        end

        def self.get_keys
          settings = YAML.load_file('.cc_api.yml')
          username = settings['cc_api_credentials']['username']
          license_key = settings['cc_api_credentials']['license_key']
          [username, license_key]
        rescue
          []
        end


        def self.write(username, license_key)
          File.open ".cc_api.yml", "w" do |file|
            settings = {
              'cc_api_credentials' => {
                'username' => username,
                'license_key' => license_key
              }
            }
            file.write(settings.to_yaml)
          end
        end
      end
    end
  end
end
