require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe SectionType do
    include RedexHelper
    before :each do
      define_test_dictionaries
      define_test_doc_type
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

    it "should be a top level section type the parent is a Document Type" do
      @section_type.parent = DocumentType.new(:some_doc_type)
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
      @section_type.starts_with :dictionary => :street_addresses
      @section_type.start_dictionary.should be_a Dictionary
      @section_type.start_dictionary.name.should == :street_addresses.to_s
    end

    it "should assign a start dictionary" do
      @section_type.ends_with :dictionary => :cities
      @section_type.end_dictionary.should be_a Dictionary
      @section_type.end_dictionary.name.should == :cities.to_s
    end

    it "should contain section types and content types" do
      @section_type.has_content :street_address, :dictionary => :street_addresses
      @section_type.has_content :phone_number, :dictionary => :phone_numbers
      @section_type.has_section :phone_number
      @section_type.children.size.should == 3
      @section_type.children.first.should be_a ContentType
      @section_type.children.last.should be_a SectionType
    end

    it "should assign a start dictionary and content type" do
      @section_type.starts_with_content :street_address, :dictionary => :street_addresses
      @section_type.start_dictionary.should be_a Dictionary
      @section_type.start_dictionary.name.should == :street_addresses.to_s
      @section_type.children.size.should == 1
      @section_type.children.first.should be_a ContentType
      @section_type.children.first.name.should == :street_address
    end

    it "should assign an end dictionary and content type" do
      @section_type.ends_with_content :zip_code, :dictionary => :zip_codes
      @section_type.end_dictionary.should be_a Dictionary
      @section_type.end_dictionary.name.should == :zip_codes.to_s
      @section_type.children.size.should == 1
      @section_type.children.first.should be_a ContentType
      @section_type.children.first.name.should == :zip_code
    end
  end
end