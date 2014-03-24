require 'spec_helper'

describe Cc::Api::Util::ConfigReader do
  it "should return the path of the config file from the CC_API_KEY from user's environment" do
    Cc::Api::Util::ConfigReader.path.should match /..\/..\/..\/config\/cc_api_keys.yml/
  end

  it "should return license key hash based from the CC_API_KEY from user's environment" do
    allow(Cc::Api::Util::ConfigReader).to receive(:get_keys).and_return "abc:123"
    Cc::Api::Util::ConfigReader.license.should eq({:username => "abc", :password => "123"})
  end

  it "should raise error if CC_API_KEY from user's environment is not found" do
    allow(Cc::Api::Util::ConfigReader).to receive(:get_keys).and_return nil
    expect {
      Cc::Api::Util::ConfigReader.license
    }.to raise_error Cc::Api::Util::LicenseKeysException 
  end

  it "should raise error if CC_API_KEY is blank" do
    allow(Cc::Api::Util::ConfigReader).to receive(:get_keys).and_return ""
    expect {
      Cc::Api::Util::ConfigReader.license
    }.to raise_error Cc::Api::Util::LicenseKeysException 
  end
end
