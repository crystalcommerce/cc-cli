module Cc
  module Api
    module Util
      class LicenseKeysException < StandardError
      end

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
            raise_license_key_exception if login.empty? || key.empty?
            [login, key]
          rescue KeyError
            raise_license_key_exception
          end

          def raise_license_key_exception
            raise LicenseKeysException, <<-EOS
License keys not set properly. Place your keys at ~/.bashrc (linux) or
~/.profile (mac). Just add these lines:

export CC_API_LOGIN=<login>
export CC_API_KEY=<key>
            EOS
          end
        end
      end
    end
  end
end
