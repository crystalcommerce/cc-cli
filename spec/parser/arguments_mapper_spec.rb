require 'spec_helper'

describe Cc::Api::Parser::ArgumentsMapper do
  describe "map" do
    let(:rand) { "123" }
    context "lattice" do
      context "products" do
        let(:args) { {:action => "lattice-products", :params => { :id => rand, :skus => [rand] } } }
        let(:wrong_args) { {:action => "this", :is => "a", :wrong => "argument" } }

        it_behaves_like "arguments mapper returning json with id and skus"
      end

      context "stores" do
        let(:args) { { :action => "lattice-stores" } }

        it_behaves_like "arguments mapper returning blank json"
      end

      context "offers" do
        let(:rand) { "123" }
        let(:args) { { :action => "lattice-offers", :params => { :id => rand, :skus => [rand] } } }

        it "matches the args and creates a json object that maps the args" do
          res = Cc::Api::Parser::ArgumentsMapper.map args
          expected_res = {id: rand, skus: [rand]}
          res.should eq expected_res
        end
      end
    end

    context "catalog" do
      context "products" do
        let(:args) { { :action => "catalog-products", :params => { :page => 1 } } }

        it_behaves_like "arguments mapper returning page params"
      end

      context "product types" do
        let(:args) { { :action => "catalog-product_types", :params => { :page => 1 } } }

        it_behaves_like "arguments mapper returning page params"
      end

      context "stores" do
        let(:args) { { :action => "catalog-stores" } }

        it_behaves_like "arguments mapper returning blank json"
      end

      context "categories" do
        let(:args) { { :action => "catalog-categories", :params => { :page => 1} } }

        it_behaves_like "arguments mapper returning page params"
      end
    end

    context "store" do
      context "products" do
        let(:store) { "arux" }
        let(:args) { { :action => "store-products", :params => { :token => "123", :store => store } } }
        
        it "matches the args and creates a json object that maps the args" do
          res = Cc::Api::Parser::ArgumentsMapper.map args
          expected_res = {token: rand, store: store}
          res.should eq expected_res
        end
      end
    end
  end
end
