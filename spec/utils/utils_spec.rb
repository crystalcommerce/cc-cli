require 'spec_helper'

describe Cc::Api::Util::ConfigReader do
  it "should return the path of the config file for the license keys" do
    Cc::Api::Util::ConfigReader.path.should match /..\/..\/..\/config\/cc_api_keys.yml/
  end

  it "should return license key hash based from the cc_api_keys.yml" do
    allow(YAML).to receive(:load_file).and_return({"license" => {"ssologin" => "abc", "key" => "123"}})
    Cc::Api::Util::ConfigReader.license.should eq({"username" => "abc", "password" => "123"})
  end

  it "should raise error if cc_api_keys.yml file is not found" do
    expect {
      Cc::Api::Util::ConfigReader.license
    }.to raise_error Cc::Api::Util::LicenseKeysException 
  end

  it "should raise error if ssologin and keys are blank" do
    allow(YAML).to receive(:load_file).and_return({})
    expect {
      Cc::Api::Util::ConfigReader.license
    }.to raise_error Cc::Api::Util::LicenseKeysException 
  end
end
