# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'webmock/rspec'
require 'cc/api/explorer'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  Dir["./spec/support/**/*.rb"].sort.each {|f| require f}
  config.include(StdoutHelper)

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234

  config.order = 'random'
  LATTICE_PRODUCTS_RESPONSE = IO.read("spec/dummy_data/lattice_products.json") # sample json response 
  LATTICE_STORES_RESPONSE = IO.read("spec/dummy_data/lattice_stores.json") # sample json response 
  CATALOG_PRODUCTS_RESPONSE = IO.read("spec/dummy_data/catalog_products.json") # sample json response 
end

