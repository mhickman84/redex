require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe ContentType do
    before :each do
      @dictionary = Dictionary.new("cast")
      @content_type = ContentType.new(:name)
    end

    it "should have an associated dictionary" do
      @content_type.dictionary = @dictionary
      @content_type.dictionary.should be_a Dictionary
    end

  end
end