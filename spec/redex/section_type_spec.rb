require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe SectionType do
    before :each do
      @section_type = SectionType.new(:test_section)
    end

    it "should have a name" do
      @section_type.name.should == :test_section
    end

    it "should allow nested section types" do
      @section_type.has_section :section_header
      @section_type.children.size.should == 1
      @section_type.children.first.should be_a SectionType
      @section_type.children.first.name.should == :section_header
    end

    it "should be a top level section type if it has no parent types" do
      @section_type.top_level?.should be_true
      @section_type.parent = SectionType.new(:some_section)
      @section_type.top_level?.should be_false
    end

    it "should allow nested content types" do
      @section_type.has_content :first_name
      @section_type.children.size.should == 1
      @section_type.children.first.should be_a ContentType
      @section_type.children.first.name.should == :first_name
    end

    it "should assign a start dictionary" do
      @section_type.starts_with :dictionary => :cast
      @section_type.start_dictionary.should be_a Dictionary
      @section_type.start_dictionary.name.should == "cast"
    end

    it "should assign a start dictionary" do
      @section_type.ends_with :dictionary => :cast
      @section_type.end_dictionary.should be_a Dictionary
      @section_type.end_dictionary.name.should == "cast"
    end

    it "should contain section types and content types" do
      @section_type.has_content :address, :dictionary => :addresses
      @section_type.has_content :phone_number, :dictionary => :phone_numbers
      @section_type.has_section :phone_number, :dictionary => :phone_numbers
      @section_type.children.size.should == 3
      @section_type.children.first.should be_a ContentType
      @section_type.children.last.should be_a SectionType
    end
  end
end