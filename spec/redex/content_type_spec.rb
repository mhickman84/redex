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

    it "should have a name" do
      @content_type.name.should == :name
    end

    it "should have an optional parent section or document" do
      @content_type.top_level?.should be_true
      @content_type.parent = SectionType.new(:some_random_section)
      @content_type.top_level?.should be_false
    end
  end
end