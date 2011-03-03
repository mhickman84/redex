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
      @section_type.section_types.size.should == 1
      @section_type.section_types.first.should be_a SectionType
      @section_type.section_types.first.name.should == :section_header
    end

    it "should allow nested content types" do
      @section_type.has_content :first_name
      @section_type.content_types.size.should == 1
      @section_type.content_types.first.should be_a ContentType
      @section_type.content_types.first.name.should == :first_name
    end

    it "should assign a start dictionary" do
      @section_type.starts_with :dictionary => :cast
      @section_type.start_dictionary.should be_a Dictionary
      @section_type.start_dictionary.name.should == "cast"
    end

  end
end