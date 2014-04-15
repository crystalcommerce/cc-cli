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

    printed.should match "\navailable columns\n====================\na.b.d.e.g\na.b.d.f\na.c\n"
  end

  it "returns the key chains of a given hash with array of hashes as an element" do
    printed = capture_stdout do
      res = Cc::Api::Util::KeyChainsGetter.get_key_chains hash_with_array, ""
    end

    printed.should match "\navailable columns\n====================\na.b.<index>.c\n"
  end

  it "ignores a keychain subset and will put a '*' as a postfix" do
    printed = capture_stdout do
      res = Cc::Api::Util::KeyChainsGetter.get_key_chains(hash, "", ["a.b.d"])
    end

    printed.should match "\navailable columns\n====================\na.b.d.\\*\na.c\n"
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
  let(:login) { 'abc' }
  let(:key) { '123' }

  around(:each) do |example|
    old_login = ENV['CC_API_LOGIN']
    old_key   = ENV['CC_API_KEY']

    begin
      ENV['CC_API_LOGIN'] = login
      ENV['CC_API_KEY']   = key
      example.run
    ensure
      ENV['CC_API_LOGIN'] = old_login
      ENV['CC_API_KEY']   = old_key
    end
  end

  it "should return license key hash based from the CC_API_KEY from user's environment" do
    license = Cc::Api::Util::ConfigReader.license
    expect(license.username).to eq('abc')
    expect(license.password).to eq('123')
  end

  context "env vars not set" do
    let(:login) { nil }
    let(:key) { nil }

    it "should raise error if CC_API_KEY from user's environment is not found" do
      expect {
        Cc::Api::Util::ConfigReader.license
      }.to raise_error Cc::Api::Util::LicenseKeysException 
    end
  end

  context "keys present but blank" do
    let(:login) { "" }
    let(:key) { "" }

    it "should raise error if CC_API_KEY is blank" do
      expect {
        Cc::Api::Util::ConfigReader.license
      }.to raise_error Cc::Api::Util::LicenseKeysException 
    end
  end
end
