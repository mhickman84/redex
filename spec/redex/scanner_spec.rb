require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Scanner do
    include RedexHelper
    before :each do
      add_dictionaries

      @doc = Document.import(File.expand_path "../../spec/document_files/episodes.txt", File.dirname(__FILE__))
      @dict = Dictionary.import(File.expand_path "../../spec/dictionary_files/cast", File.dirname(__FILE__))

      letter_path = File.expand_path "../../spec/document_files/letters/sample_letter.txt", File.dirname(__FILE__)
      @letter = Document.import(letter_path, :type => :letter)

      letter_2_path = File.expand_path "../../spec/document_files/letters/sample_letter_2.txt", File.dirname(__FILE__)
      @letter_2 = Document.import(letter_2_path, :type => :letter)
      @scanner = Scanner.new :letter
    end

    it "should create a match object when given a dictionary and a line containing a match" do
      match = @scanner.find_match(@dict, @doc.line(1))
      match.should be_a Match
      match.content.to_s.should == "Frank"
      match.dictionary.should == @dict
      match = @scanner.find_match(@zip_codes, @letter.line(2))
      match.should be_a Match
      match.content.to_s.should == "65286"
    end

    it "should return nil when given a dictionary and a line that doesn't contain a match" do
      puts "DOC LINE 4: #{@doc.line(4).inspect}"
      @dict.each { |item| puts "ITEM: #{item.inspect} SCORE: #{item.score} INDEX: #{item.index}" }
      @dict.take(4) { |item| item.increment }
      @dict.each { |item| puts "ITEM: #{item.inspect} SCORE: #{item.score} INDEX: #{item.index}" }
      match = @scanner.find_match(@dict, @doc.line(4))
      match.should be_nil
    end

    it "should assign a document type on initialization" do
      @scanner.instance_variable_get(:@doc_type).should be_a DocumentType
    end

    it "should return a collection of outer sections to search for in the document" do
      letter_sections = @scanner.outer_section_types
      letter_sections.size.should == 2
      letter_sections.all? { |section| section.should be_a SectionType }
      letter_sections.first.name.should == :return_address
      letter_sections.last.name.should == :salutation
    end

    it "should return match objects for each of the outer sections" do
      matches = []
      @letter.lines.each do |line|
         matches.concat(@scanner.scan_outer_sections line)
      end
      puts "MATCHES: #{matches.inspect}"
      matches.size.should == 5
      return_address_matches = matches.select { |match| match.belongs_to == :return_address }
      return_address_matches.size.should == 4
      salutation_matches = matches.select { |match| match.belongs_to == :salutation }
      salutation_matches.size.should == 1
      start_matches = matches.select { |match| match.type == :start_section }
      start_matches.size.should == 3
      end_matches = matches.select { |match| match.type == :end_section }
      end_matches.size.should == 2

      match_content = matches.map { |match| match.content[0] }
      match_content.should include "3519 Front Street", "65286", "765 Berliner Plaza", "68534", "Dear Ms. Johnson:"
    end

    it "should return match objects for each of the outer contents" do
      matches = []
      @letter.lines.each do |line|
        matches.concat(@scanner.scan_outer_contents line)
      end
      puts "OUTER CONTENT MATCHES: #{matches.inspect}"
      matches.size.should == 3
      matches[0].content.to_s.should == 'Johnson'
      matches[1].content.to_s.should == 'Johnson'
      matches[2].content.to_s.should == 'Powers'
    end

    describe "#scan" do
      before(:each) { @outer_matches = @scanner.scan @letter }

      it "should return all outer section and content matches for a document" do
        puts "Dictionaries: #{Redex.configuration.dictionaries.inspect}"
        @outer_matches.each { |match| puts "MATCH: " + match.content.to_s }
        @outer_matches.should be_a Array
        @outer_matches.size.should == 8
      end

      it "should return all matches in order" do
        @outer_matches.first.content.to_s.should == '3519 Front Street'
        @outer_matches.last.content.to_s.should == 'Powers'
      end
    end

    after :each do
      Document.clear
      Dictionary.clear
      remove_dictionaries
    end
  end
end