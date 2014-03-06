require 'spec_helper'

#TODO dry this up
describe Cc::Api::Parser::ArgumentsMapper do
  describe "map" do
    context "lattice" do
      context "products" do
        let(:rand) { "123" }
        let(:args) { ["lattice-products", "--id", rand, "--skus", rand] }
        let(:args2) { ["lattice-products", "--skus", rand, "--id", rand] }
        let(:wrong_args) { ["this", "is", "a", "wrong", "argument"] }

        it "matches the args and creates a json object that maps the args" do
          res = Cc::Api::Parser::ArgumentsMapper.map args
          expected_res = {id: rand, skus: [rand]}
          res.should eq expected_res
        end

        it "matches the args (--sku before --id) and creates a json object that maps the args" do
          res = Cc::Api::Parser::ArgumentsMapper.map args2
          expected_res = {id: rand, skus: [rand]}
          res.should eq expected_res
        end

        it "doesn't match" do
          res = Cc::Api::Parser::ArgumentsMapper.map wrong_args
          res.should eq nil
        end
      end

      context "stores" do
        let(:rand) { "123" }
        let(:args) { ["lattice-stores"] }

        it "matches the args and creates a json object that maps the args" do
          res = Cc::Api::Parser::ArgumentsMapper.map args
          expected_res = {}
          res.should eq expected_res
        end
      end

      context "offers" do
        let(:rand) { "123" }
        let(:args) { ["lattice-offers", "--id", rand, "--skus", rand] }

        it "matches the args and creates a json object that maps the args" do
          res = Cc::Api::Parser::ArgumentsMapper.map args
          expected_res = {id: rand, skus: [rand]}
          res.should eq expected_res
        end
      end
    end

    context "catalog" do
      context "products" do
        let(:args) { ["catalog-products"] }
        it "matches the args and creates a json object that maps the args" do
          res = Cc::Api::Parser::ArgumentsMapper.map args
          expected_res = {}
          res.should eq expected_res
        end
      end

      context "product types" do
        let(:args) { ["catalog-product_types"] }
        it "matches the args and creates a json object that maps the args" do
          res = Cc::Api::Parser::ArgumentsMapper.map args
          expected_res = {}
          res.should eq expected_res
        end
      end
    end
  end
end
