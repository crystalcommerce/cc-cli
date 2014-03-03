require 'cc/api/explorer/version'
require 'thor'
require 'command_line_reporter'
require 'cc/api/http/http_requestor'

module Cc
  module Api
    module Explorer
      class CLI < Thor
        desc "latticeproducts", "Returns <Store Name | Qty | Sell Price | Buy Price>"
        def latticeproducts *args
          args.unshift "lattice-products"
          puts Cc::Api::Http::HttpRequestor.request_for_json
        end
      end
    end
  end
end
