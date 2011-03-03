require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Configuration do
    before :each do
      @config = Configuration.new
    end
    it "should define accessor methods for configuration options" do
      Configuration.define_setting :foo
      @config.foo = "bar"
      @config.foo.should == "bar"
      @config.settings[:foo].should == "bar"
    end

    it "should fall back on default values when supplied" do
      Configuration.define_setting :one, :default => 1
      @config.one.should == 1
    end
  end
end