require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Parser do
    include RedexHelper
    before :each do
      define_test_dictionaries
      define_test_doc_type
      letter_path = File.expand_path "../../spec/document_files/letters/sample_letter.txt", File.dirname(__FILE__)
      @letter = Document.import(letter_path, :type => :letter)
      @matches = Scanner.new(:letter).scan(@letter)
      @parser = Parser.new(:letter)
    end

    it "should require a document type that has been defined" do
      @parser.should be_a Parser
      lambda { Parser.new(:fake_doc_type) }.should raise_error
    end

    describe "#parse_sections_of_type" do
      before(:each) { @address_sections = @parser.parse_sections_of_type(:address, @matches) }

      it "should create sections of the supplied type from a list of section matches" do
        @address_sections.all? { |content| content.should be_a DocumentSection }
        @address_sections.all? { |section| section.type.should == :address }
      end

      it "should create 1 section for each pair of :start and :end section matches" do
        @address_sections.size.should == 2
      end
    end

    describe "#parse_contents_of_type" do
      before(:each) do
        @last_name_contents = @parser.parse_contents_of_type(:last_name, @matches)
      end

      it "should create contents matching the specified type from a list of content matches" do
        @last_name_contents.all? { |content| content.should be_a DocumentContent }
        @last_name_contents.all? { |content| content.type.should == :last_name }
      end

      it "should create 1 DocumentContent object for each match" do
        @last_name_contents.size.should == 3
      end
    end

    describe "#parse" do
      before :each do
        @letter.parsed?.should be_false
        @parsed_letter = @parser.parse @letter
      end
      
      it "should accept an unparsed document and return a parsed document" do
        @parsed_letter.parsed?.should be_true
      end

      it "should populate the document with the outermost sections" do
        sections = @parsed_letter.sections
        sections.size.should == 3
        sections.all? { |s| s.should be_a DocumentSection }
        sections.first.type.should == :address
        sections.last.type.should == :salutation
      end

      it "should populate the document with the outermost contents" do
        contents = @parsed_letter.contents
        contents.size.should == 3
        contents.all? { |c| c.should be_a DocumentContent }
        contents.all? { |c| c.type.should == :last_name }
      end
    end
  end
end