require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Parser do
    include RedexHelper
    before :each do
      define_test_dictionaries
      define_test_doc_type
      letter_path = File.expand_path "../../spec/document_files/letters/sample_letter.txt", File.dirname(__FILE__)
      @letter = Document.import(letter_path, :type => :letter)
      @scanner = Scanner.new(:letter)
      @parser = Parser.new(:letter)
    end

    it "should require a document type that has been defined" do
      parser = Parser.new(:letter)
      parser.should be_a Parser
      lambda { Parser.new(:fake_doc_type) }.should raise_error
    end

    describe "#parse_sections_of_type" do
      it "should create sections of the supplied type from a list of section matches" do
        matches = @scanner.scan(@letter)
        matches.each { |m| puts "MATCH: #{m}" }
        letter_sections = @parser.parse_sections_of_type(:address, matches)
        letter_sections.all? { |section| section.type.should == :address }
      end
    end

    describe "#parse_contents_of_type" do
      it "should create contents from a list of content matches" do
        matches = @scanner.scan(@letter)
        letter_contents = @parser.parse_contents_of_type(:address, matches)
        letter_contents.all? { |content| content.should be_a DocumentContent }
      end
    end
  end
end