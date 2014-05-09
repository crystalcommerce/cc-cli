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

    it "creates a '.cc_api.yml' and saved user/pass in it" do
      file = mock('file')
      File.should_receive(:open).with(".cc_api.yml", "w").and_yield(file)
      file.should_receive(:write).with("---\ncc_api_credentials:\n  username: john\n  license_key: 1231239asjh123uasdh123\n")
      Cc::Api::Util::CredentialWriter.write('john', '1231239asjh123uasdh123')
    end
  end

end
