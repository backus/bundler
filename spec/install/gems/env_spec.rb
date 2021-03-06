require "spec_helper"

describe "bundle install with ENV conditionals" do
  describe "when just setting an ENV key as a string" do
    before :each do
      gemfile <<-G
        source "file://#{gem_repo1}"

        env "BUNDLER_TEST" do
          gem "rack"
        end
      G
    end

    it "excludes the gems when the ENV variable is not set" do
      bundle :install
      should_not_be_installed "rack"
    end

    it "includes the gems when the ENV variable is set" do
      ENV["BUNDLER_TEST"] = "1"
      bundle :install
      should_be_installed "rack 1.0"
    end
  end

  describe "when just setting an ENV key as a symbol" do
    before :each do
      gemfile <<-G
        source "file://#{gem_repo1}"

        env :BUNDLER_TEST do
          gem "rack"
        end
      G
    end

    it "excludes the gems when the ENV variable is not set" do
      bundle :install
      should_not_be_installed "rack"
    end

    it "includes the gems when the ENV variable is set" do
      ENV["BUNDLER_TEST"] = "1"
      bundle :install
      should_be_installed "rack 1.0"
    end
  end

  describe "when setting a string to match the env" do
    before :each do
      gemfile <<-G
        source "file://#{gem_repo1}"

        env "BUNDLER_TEST" => "foo" do
          gem "rack"
        end
      G
    end

    it "excludes the gems when the ENV variable is not set" do
      bundle :install
      should_not_be_installed "rack"
    end

    it "excludes the gems when the ENV variable is set but does not match the condition" do
      ENV["BUNDLER_TEST"] = "1"
      bundle :install
      should_not_be_installed "rack"
    end

    it "includes the gems when the ENV variable is set and matches the condition" do
      ENV["BUNDLER_TEST"] = "foo"
      bundle :install
      should_be_installed "rack 1.0"
    end
  end

  describe "when setting a regex to match the env" do
    before :each do
      gemfile <<-G
        source "file://#{gem_repo1}"

        env "BUNDLER_TEST" => /foo/ do
          gem "rack"
        end
      G
    end

    it "excludes the gems when the ENV variable is not set" do
      bundle :install
      should_not_be_installed "rack"
    end

    it "excludes the gems when the ENV variable is set but does not match the condition" do
      ENV["BUNDLER_TEST"] = "fo"
      bundle :install
      should_not_be_installed "rack"
    end

    it "includes the gems when the ENV variable is set and matches the condition" do
      ENV["BUNDLER_TEST"] = "foobar"
      bundle :install
      should_be_installed "rack 1.0"
    end
  end
end
