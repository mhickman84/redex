require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Parser do
    include RedexHelper
    before :each do
      add_dictionaries

      @doc = Document.import(File.expand_path "../../spec/document_files/episodes.txt", File.dirname(__FILE__))
      @dict = Dictionary.import(File.expand_path "../../spec/dictionary_files/cast", File.dirname(__FILE__))

      letter_path = File.expand_path "../../spec/document_files/letters/sample_letter.txt", File.dirname(__FILE__)
      @letter = Document.import(letter_path, :type => :letter)

      letter_2_path = File.expand_path "../../spec/document_files/letters/sample_letter_2.txt", File.dirname(__FILE__)
      @letter_2 = Document.import(letter_2_path, :type => :letter)
      @parser = Parser.new
    end

    it "should create a match object when given a dictionary and a line containing a match" do
      match = @parser.find_match(@dict, @doc.line(1))
      match.should be_a Match
      match.content.should == "Frank"
      match.dictionary.should == @dict

      match = @parser.find_match(@zip_codes, @letter.line(2))
      match.should be_a Match
      match.content.should == "65286"
    end

    it "should return nil when given a dictionary and a line that doesn't contain a match" do
      puts "DOC LINE 4: #{@doc.line(4).inspect}"
      @dict.each { |item| puts "ITEM: #{item.inspect} SCORE: #{item.score} INDEX: #{item.index}" }
      @dict.take(4) { |item| item.increment }
      @dict.each { |item| puts "ITEM: #{item.inspect} SCORE: #{item.score} INDEX: #{item.index}" }
      match = @parser.find_match(@dict, @doc.line(4))
      match.should be_nil
    end

    it "should find matches within a document for a section type" do
      return_address_matches = @parser.match_section(:return_address, @letter)
      return_address_matches.size.should == 2
      puts "RETURN ADDRESS MATCHES: #{return_address_matches.inspect}"
      return_address_matches.all? { |match| match.should be_a Match }
      return_address_matches.first.flags.should include :start_section, :content
      return_address_matches.last.flags.should include :end_section, :content
    end

    it "should parse a single content item"

    it "should parse the outer sections of a document" do
      pending
      @parser.parse_outer_sections(@letter)
    end

    it "should parse the outer contents of a document" do
      pending
    end

    after :each do
      Document.clear
      Dictionary.clear
      remove_dictionaries
    end
  end
end