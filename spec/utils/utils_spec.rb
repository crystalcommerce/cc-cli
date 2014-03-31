require 'spec_helper'

describe Cc::Api::Util::KeyChainsGetter do
  let(:hash) { { :a => { :b => { :d => { :e =>  { :g => "end"}, :f => "end" } }, :c => "end" } } }
  let(:target_array) { [{ :c => "end"}] }
  let(:hash_with_array) { { 'a' => { 'b' => target_array } } }
  it "returns the key chains of a given hash" do
    #TODO: What if value is an Array? e.g. { :a => { :b => { :d => { :e =>  { :g => ["what", "if", "im", "an", "array"]}, :f => "end" } }, :c => "end" } }
    printed = capture_stdout do
      res = Cc::Api::Util::KeyChainsGetter.get_key_chains hash, ""
    end

    printed.should match "\navailable key-chains\n====================\na.b.d.e.g\na.b.d.f\na.c\n"
  end

  it "returns the key chains of a given hash with array of hashes as an element" do
    printed = capture_stdout do
      res = Cc::Api::Util::KeyChainsGetter.get_key_chains hash_with_array, ""
    end

    printed.should match "\navailable key-chains\n====================\na.b.<index>.c\n"
  end


  it "returns the target array" do
    res = Cc::Api::Util::KeyChainsGetter.get_target_array hash_with_array, "a.b"
    res.should eq target_array
  end

  it "throws exception with target not found" do
    printed = capture_stdout do
      res = Cc::Api::Util::KeyChainsGetter.get_target_array hash_with_array, "a.b.c"
    end
    printed.should eq "Target not found.\n"
  end
end

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


