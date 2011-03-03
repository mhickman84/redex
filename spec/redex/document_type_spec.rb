require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe DocumentType do
    before :each do
      @doc_type = DocumentType.new(:letter)
    end

    it "should be able to add section types" do
      @doc_type.has_section :header
      @doc_type.section_types.size.should == 1
      @doc_type.section_types.first.should be_a SectionType
      @doc_type.section_types.first.name.should == :header
    end

    it "should be able to add content types" do
      @doc_type.has_content :phone_number
      @doc_type.content_types.size.should == 1
      @doc_type.content_types.first.should be_a ContentType
      @doc_type.content_types.first.name.should == :phone_number
    end

    it "should support block initialization" do
      doc_type = DocumentType.new :test_doc do |d|
        d.should be_a DocumentType
        d.has_section :body
        d.has_content :name
      end
      doc_type.name.should == :test_doc
      doc_type.section_types.first.should be_a SectionType
      doc_type.section_types.first.name.should == :body
      doc_type.content_types.first.should be_a ContentType
      doc_type.content_types.first.name.should == :name
    end
  end
end