require 'spec_helper'

describe Cc::Api::Http::HttpRequestor do
  before(:each) do
    allow(Cc::Api::Util::ConfigReader).to receive(:get_keys).and_return "abc:123"
  end

  context "returns valid JSON response for a post request" do
    let(:param) { {request: { url: "https://abc:123@api.crystalcommerce.com/v1/lattice/offers", :body=>{"search"=>{"skus"=>{"201750"=>["123abc", "456def"]}}}, method: "POST"} } }

    it "returns valid JSON response for a post request" do
      stub_request(:post, "https://abc:123@api.crystalcommerce.com/v1/lattice/offers").
        with(:body => "{\"search\":{\"skus\":{\"201750\":[\"123abc\",\"456def\"]}}}", :headers => {"Content-Type" => "application/json"}).
        to_return(:status => 200, :body => LATTICE_OFFERS_RESPONSE, :headers => {"Content-Type" => "application/json"})

      result = Cc::Api::Http::HttpRequestor.request_for_json param
      result.should_not eq nil

    end
  end

  context "raises error" do
    let(:param) { {request: { url: "https://abc:123@api.crystalcommerce.com/v1/lattice/offers", :body=>{"search"=>{"skus"=>{"201750"=>["123abc", "456def"]}}}, method: "POST"} } }

    it "if license keys are not set properly" do
      allow(Cc::Api::Util::ConfigReader).to receive(:get_keys).and_return ""
      expect {
        Cc::Api::Http::HttpRequestor.request_for_json param
      }.to raise_error Cc::Api::Util::LicenseKeysException
    end

    it "if not enough privileges" do
      stub_request(:post, "https://abc:123@api.crystalcommerce.com/v1/lattice/offers").
        with(:body => "{\"search\":{\"skus\":{\"201750\":[\"123abc\",\"456def\"]}}}", :headers => {"Content-Type" => "application/json"}).
        to_return(:status => 401, :body => "", :headers => {"Content-Type" => "application/json"})

      expect {
        Cc::Api::Http::HttpRequestor.request_for_json param
      }.to raise_error Cc::Api::Http::UnauthorizedAccessException
    end

    it "if there's a server error" do
      stub_request(:post, "https://abc:123@api.crystalcommerce.com/v1/lattice/offers").
        with(:body => "{\"search\":{\"skus\":{\"201750\":[\"123abc\",\"456def\"]}}}", :headers => {"Content-Type" => "application/json"}).
        to_return(:status => 500, :body => "", :headers => {"Content-Type" => "application/json"})

      expect {
        Cc::Api::Http::HttpRequestor.request_for_json param
      }.to raise_error Cc::Api::Http::ServerProblemException
    end
  end
end
