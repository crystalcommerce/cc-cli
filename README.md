# CrystalCommerce CLI

This is a command line client for exploring Crystal Commerce APIs

## Installation

Add this line to your application's Gemfile:

    gem 'cc-cli', :git => "git@github.com:crystalcommerce/cc-cli.git"

And then execute:

    $ bundle

Or install it yourself as a gem:

    $ gem install cc-cli

## Usage

To view help:

    $ cc-cli

The license key pair `<ssologin>` and `<key>` are basically just basic auth username and password respectively.
To obtain a license key, contact: Jerad Ellison or call (206) 274-7437 Ext. 3.

Add these lines in your ~/.bashrc (linux) or ~/.profile (mac) file:

    export CC_API_LOGIN=<login>
    export CC_API_KEY=<key>

If you are working in a project, you can also install the
[dotenv](http://rubygems.org/gems/dotenv) gem and put a .env file in
the working directory that looks like:

    CC_API_LOGIN=<login>
    CC_API_KEY=<key>

You can then run the program with `dotenv cc-cli`. This approach will
be advantageous if you don't want to edit your user's shell config to
use this tool.

These are the available commands:

    $ cc-cli catalog [products] | [product_types] | [stores] | [categories]
    $ cc-cli help [COMMND]
    $ cc-cli lattice [products --id <PRODUCT ID> --skus <PRODUCT SKUS separated by ','>] | [offers --id <PRODUCT ID> --skus <PRODUCT SKUS separated by ','>] | [stores]
    $ cc-cli store [products --token <access token> --store <store name>]

To choose columns/json keys to display:

  Display the available 'key-chains' for a given command. Say for example `$ cc-cli catalog products`:

    $ cc-cli catalog products --keychains

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
    --cols descriptors.Name,descriptors.Pow/Tgh,seoname

  Then display the table

    $ cc-cli catalog products --cols descriptors.Name,descriptors.Pow/Tgh,seoname
    GET https://api.crystalcommerce.com/v1/catalog/products?page=1
    response time: 2.091034343
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃      descriptors.Name          ┃      descriptors.Pow/Tgh       ┃      seoname                   ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Abyssal Specter           ┃      2/3                       ┃      abyssal_specter           ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Air Elemental             ┃      4/4                       ┃      air_elemental             ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Aladdin's Ring            ┃                                ┃      aladdins_ring             ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Ambition's Cost           ┃                                ┃      ambitions_cost            ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Anaba Shaman              ┃      2/2                       ┃      anaba_shaman              ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃      Angel of Mercy            ┃      3/3                       ┃      angel_of_mercy            ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  When `--cols` is not used, the default `--cols` values will then be selected.

  This is also capable of displaying values from arrays within the JSON object from the API response. For example let's first print `$ cc-cli catalog product_types` 'key-chains':

    $ cc-cli catalog product_types --keychains
    GET https://api.crystalcommerce.com/v1/catalog/product_types?page=1
    response time: 1.654095542

    available key-chains
    ====================
    id
    name
    default_weight
    amazon_search_index
    variant_dimensions.<index>.name
    variant_dimensions.<index>.product_type_id
    variant_dimensions.<index>.default_option_id
    variant_dimensions.<index>.options.<index>.value
    variant_dimensions.<index>.options.<index>.code
    descriptors.<index>.name

  The `<index>` must be replaced by an integer:

    $ cc-cli catalog product_types --cols name,variant_dimensions.0.name,variant_dimensions.0.default_option_id --colp 1
    GET https://api.crystalcommerce.com/v1/catalog/product_types?page=1
    response time: 1.389229104
    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    ┃  name                          ┃  variant_dimensions.0.name     ┃  variant_dimensions.0.default  ┃
    ┃                                ┃                                ┃  _option_id                    ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Pathfinder                    ┃  Condition                     ┃  94                            ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Horrorclix                    ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Misc Products for Mad Al      ┃  Condtion                      ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Miniatures Sealed Product     ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Dragon Ball CCG Sealed        ┃  Condition                     ┃  753                           ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Battle Spirits Sealed Produc  ┃  Condition                     ┃                                ┃
    ┃  t                             ┃                                ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Other Card Games - Sealed     ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Axis & Allies: Air Force Min  ┃  Condition                     ┃                                ┃
    ┃  iatures Singles               ┃                                ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  DVDs                          ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Sportscards & Trading Cards   ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Toys                          ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Video Game Accessories        ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Kaijudo Sealed Product        ┃  Condition                     ┃  96                            ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Candy                         ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Marvel Super Hero Squad       ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Pathfinder Miniatures         ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Cardfight! Vanguard Sealed P  ┃  Condition                     ┃  163                           ┃
    ┃  roduct                        ┃                                ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Cthulhu Tech                  ┃  Condition                     ┃                                ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Cardfight!! Vanguard          ┃  Condition                     ┃  86                            ┃
    ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
    ┃  Axis & Allies: War At Sea Mi  ┃  Condition                     ┃                                ┃
    ┃  niatures                      ┃                                ┃                                ┃
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

Other available options:

    [--offset=N]            # Offset of the starting row to be displayed. Nothing is displayed when out of bounds.
    [--limit=N]             # Limit of rows to be displayed.
    [--colw=N]              # Width of every column to be displayed.
    [--colp=N]              # Padding of every cell to be displayed.
    [--json]                # Prints the JSON response body instead.
    [--page=N]              # Page number of the response.
    [--csv=CSV_FILE_PATH]   # Print out the result into a csv file. Columns are separated by comma

## ISSUES

There is going to be an issue when trying to include as a `--cols` value a 'key-chain' that has a whitespace within its string. E.g. "descriptors.Set Name" for `$ cc-cli catalog products`
