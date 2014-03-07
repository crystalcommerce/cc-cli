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

        it_behaves_like "arguments mapper returning json with id and skus"

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
        let(:args) { ["lattice-stores"] }

        it_behaves_like "arguments mapper returning blank json"
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

        it_behaves_like "arguments mapper returning blank json"
      end

      context "product types" do
        let(:args) { ["catalog-product_types"] }

        it_behaves_like "arguments mapper returning blank json"
      end

      context "stores" do
        let(:args) { ["catalog-stores"] }

        it_behaves_like "arguments mapper returning blank json"
      end

      context "categories" do
        let(:args) { ["catalog-categories"] }

        it_behaves_like "arguments mapper returning blank json"
      end
    end
  end
end
