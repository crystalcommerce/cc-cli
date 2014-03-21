# CC API EXPLORER

This is a command line client for exploring Crystal Commerce APIs

## Installation

Add this line to your application's Gemfile:

    gem 'cc-api-explorer', :git => "git@github.com:crystalcommerce/cc-api-explorer.git"

And then execute:

    $ bundle

Or install it yourself as (not yet available as of the moment):

    $ gem install cc-api-explorer

## Usage

To view help:

    $ cc

First config/cc_api_keys.yml must be generated. In order to generate:

    $ cc init --ssologin <ssologin> --key <key>

The license key pair `<ssologin>` and `<key>` are basically just basic auth username and password respectively.
To obtain a license key, contact: contact: Jerad Ellison or call (206) 274-7437 Ext. 3.

These are the available commands:

    cc catalogcategories                                                # returns < name | seoname | description | available_on | set_code | product_type_id >
    cc catalogproducts                                                  # returns < name | seoname | category_name | weight | description >
    cc catalogproducttypes                                              # returns < name | default_weight | amazon_search_index | weight >
    cc catalogstores                                                    # returns < name | address1 | address2 | postal_code | city | state | country >
    cc latticeoffers --id ID --skus <array of skus separated by ','>    # returns < name | postal_code | url >
    cc latticeproducts --id ID --skus <array of skus separated by ','>  # returns < storename | qty | inventory_qty | sell_price | buy_price > 
    cc latticestores                                                    # returns < name | postal_code | url >

## TODO

In the future this gem will use CrystalCommerce's API Aggregator as soon as it goes live. But for now it accesses directly CC's API endpoints.

## ISSUES

It seems like https://api.crystalcommerce.com/v1/lattice is problematic right now so `cc latticeoffers`, `cc latticeproducts` and `cc latticestores` will not work as of the moment.
