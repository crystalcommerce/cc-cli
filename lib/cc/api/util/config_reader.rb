module Cc
  module Api
    module Util

      class ConfigReader
        License = Struct.new(:username, :password)

        class << self
          def license
            License.new(*get_keys)
          end

        private
          def get_keys
            login = ENV.fetch("CC_API_LOGIN")
            key   = ENV.fetch("CC_API_KEY")
            if login.empty? || key.empty?
              read_get_cc_keys
            else
              [login, key]
            end
          rescue KeyError
            read_get_cc_keys
          end

          def read_get_cc_keys
            keys = Cc::Api::Util::CredentialWriter.get_keys
            (keys.empty? && Cc::Api::Util::CredentialWriter.setup) || keys
          end
        end
      end
    end
  end
end
