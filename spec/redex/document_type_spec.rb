require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe DocumentType do
    before(:each) do
      @letter_doc_type = Redex.define_doc_type :letter
      @test_doc_type = DocumentType.new :test_doc do |d|
        d.should be_a DocumentType
        d.has_section :body
        d.has_section :footer
        d.has_content :name
      end
    end

    it "should be able to add section types" do
      @letter_doc_type.has_section :header
      @letter_doc_type.children.size.should == 1
      @letter_doc_type.children.first.should be_a SectionType
      @letter_doc_type.children.first.name.should == :header
    end

    it "should be able to add content types" do
      @letter_doc_type.has_content :phone_number
      @letter_doc_type.children.size.should == 1
      @letter_doc_type.children.first.should be_a ContentType
      @letter_doc_type.children.first.name.should == :phone_number
    end

    it "should support block initialization" do
      @test_doc_type.name.should == :test_doc
      @test_doc_type.children.first.should be_a SectionType
      @test_doc_type.children.first.name.should == :body
      @test_doc_type.children.last.should be_a ContentType
      @test_doc_type.children.last.name.should == :name
    end

    it "should retrieve document type objects by name" do
      letter = DocumentType.get(:letter)
      letter.should be_a DocumentType
      letter.name.should == :letter
    end

    it "should return a list of section types and content types contained within" do
      @test_doc_type.children.size.should == 3
    end

    it "should return the child section types" do
      @test_doc_type.section_types.size.should == 2
      @test_doc_type.section_types.all? { |type| type.should be_a SectionType }
    end

    it "should return the child content types" do
      @test_doc_type.content_types.size.should == 1
      @test_doc_type.content_types.all? { |type| type.should be_a ContentType }
    end

    after(:each) { Redex.configuration.document_types = {} }
  end
end