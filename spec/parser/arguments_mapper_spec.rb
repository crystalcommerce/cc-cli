require 'cc/api/parser/arguments_mapper'

describe Cc::Api::Parser::ArgumentsMapper do
  describe "map" do
    context "lattice" do
      let(:rand) { 123 }
      let(:args) { ["lattice-products", "--id", rand, "--sku", rand] }
      let(:wrong_args) { ["this", "is", "a", "wrong", "argument"] }

      it "matches the args and creates a json object that maps the args" do
        res = Cc::Api::Parser::ArgumentsMapper.map args
        expected_res = {id: rand, skus: rand}
        res.should eq expected_res
      end

      it "doesn't match" do
        res = Cc::Api::Parser::ArgumentsMapper.map wrong_args
        res.should eq nil
      end
    end
  end
end
