# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'webmock/rspec'
require 'cc/api/explorer'
require 'pry'

def suppress_stdouts config #need to suppress command_line_reporter's output
  original_stderr = $stderr
  original_stdout = $stdout
  config.before(:all) do
    # Redirect stderr and stdout
    $stderr = File.new(File.join(File.dirname(__FILE__), 'dev', 'null.txt'), 'w')
    $stdout = File.new(File.join(File.dirname(__FILE__), 'dev', 'null.txt'), 'w')
  end
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end

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

  #suppress_stdouts config

  MARKET_DATA_PRODUCTS_RESPONSE = File.read("spec/dummy_data/market_data_products.json") # sample json response
  MARKET_DATA_STORES_RESPONSE = File.read("spec/dummy_data/market_data_stores.json") # sample json response
  MARKET_DATA_OFFERS_RESPONSE = File.read("spec/dummy_data/market_data_offers.json") # sample json response
  CATALOG_PRODUCTS_RESPONSE = File.read("spec/dummy_data/catalog_products.json") # sample json response
  CATALOG_PRODUCT_TYPES_RESPONSE = File.read("spec/dummy_data/catalog_product_types.json") # sample json response
  CATALOG_STORES_RESPONSE = File.read("spec/dummy_data/catalog_stores.json") # sample json response
  CATALOG_CATEGORIES_RESPONSE = File.read("spec/dummy_data/catalog_categories.json") # sample json response
  STORE_PRODUCTS_RESPONSE = File.read("spec/dummy_data/store_products.json") # sample json response
end
