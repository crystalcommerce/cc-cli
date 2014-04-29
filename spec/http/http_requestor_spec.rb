require 'spec_helper'

describe Cc::Api::Http::HttpRequestor do
  let(:license) { double("License", :username => 'abc', :password => "123")}

  before(:each) do
    Cc::Api::Util::ConfigReader.stub(:license).and_return(license)
  end

  context "returns valid JSON response for a post request" do
    let(:param) { {request: { url: "https://abc:123@api.crystalcommerce.com/v1/market_data/offers", :body=>{"search"=>{"skus"=>{"201750"=>["123abc", "456def"]}}}, method: "POST"} } }

    it "returns valid JSON response for a post request" do
      stub_request(:post, "https://abc:123@api.crystalcommerce.com/v1/market_data/offers").
        with(:body => "{\"search\":{\"skus\":{\"201750\":[\"123abc\",\"456def\"]}}}", :headers => {"Content-Type" => "application/json"}).
        to_return(:status => 200, :body => MARKET_DATA_OFFERS_RESPONSE, :headers => {"Content-Type" => "application/json"})

      result = subject.request_for_json param
      result.should_not eq nil

    end
  end

  context "raises error" do
    let(:param) { {request: { url: "https://abc:123@api.crystalcommerce.com/v1/market_data/offers", :body=>{"search"=>{"skus"=>{"201750"=>["123abc", "456def"]}}}, method: "POST"} } }

    it "if license keys are not set properly" do
      Cc::Api::Util::ConfigReader.stub(:license).and_raise(Cc::Api::Util::LicenseKeysException)
      expect {
        subject.request_for_json param
      }.to raise_error(Cc::Api::Util::LicenseKeysException)
    end

    it "if not enough privileges" do
      stub_request(:post, "https://abc:123@api.crystalcommerce.com/v1/market_data/offers").
        with(:body => "{\"search\":{\"skus\":{\"201750\":[\"123abc\",\"456def\"]}}}", :headers => {"Content-Type" => "application/json"}).
        to_return(:status => 401, :body => "", :headers => {"Content-Type" => "application/json"})

      expect {
        subject.request_for_json param
      }.to raise_error Cc::Api::Http::UnauthorizedAccessException
    end

    it "if there's a server error" do
      stub_request(:post, "https://abc:123@api.crystalcommerce.com/v1/market_data/offers").
        with(:body => "{\"search\":{\"skus\":{\"201750\":[\"123abc\",\"456def\"]}}}", :headers => {"Content-Type" => "application/json"}).
        to_return(:status => 500, :body => "", :headers => {"Content-Type" => "application/json"})

      expect {
        subject.request_for_json param
      }.to raise_error Cc::Api::Http::ServerProblemException
    end
  end
end
