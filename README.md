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

The license key pair `<ssologin>` and `<key>` are basically just basic auth username and password respectively.
To obtain a license key, contact: contact: Jerad Ellison or call (206) 274-7437 Ext. 3.

Add this line in your ~/.bashrc (linux) or ~/.profile (mac) file

    export CC_API_KEY=<ssologin>:<key>

These are the available commands:

    $ cc catalog [products] | [product_types] | [stores] | [categories]
    $ cc help [COMMAND]
    $ cc lattice [products --id <PRODUCT ID> --skus <PRODUCT SKUS separated by ','>] | [offers --id <PRODUCT ID> --skus <PRODUCT SKUS separated by ','>] | [stores]
    $ cc store [products --token <access token> --store <store name>]

To choose columns/json keys to display:

  Display the available 'key-chains' for a given command. Say for example `cc catalog products`:

    $ cc catalog products --keychains

    available key-chains
    ====================
    id
    name
    seoname
    category_name
    weight
    description
    asin
    category_id
    product_type_id
    descriptors.Pow/Tgh
    descriptors.Name
    descriptors.Color
    descriptors.Cost
    descriptors.Rarity
    descriptors.Card Text
    descriptors.Finish
    descriptors.Card Type
    descriptors.Set Name
    photo.content_type
    photo.urls.medium
    photo.urls.thumb
    photo.urls.large
    photo.urls.ebay

    USAGE:
    --cols id,descriptors.Set Name,descriptors.Cost 
