require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Scanner do
    include RedexHelper
    before :each do
      define_test_dictionaries
      define_test_doc_type

      doc_path = File.expand_path "../../spec/document_files/episodes.txt", File.dirname(__FILE__)
      @doc = Document.import(doc_path, :type => :test_doc)
      dict_path = File.expand_path "../../spec/dictionary_files/cast", File.dirname(__FILE__)
      @dict = Dictionary.import(dict_path)

      letter_path = File.expand_path "../../spec/document_files/letters/sample_letter.txt", File.dirname(__FILE__)
      @letter = Document.import(letter_path, :type => :letter)

      letter_2_path = File.expand_path "../../spec/document_files/letters/sample_letter_2.txt", File.dirname(__FILE__)
      @letter_2 = Document.import(letter_2_path, :type => :letter)
      @scanner = Scanner.new :letter
    end

    it "should create a match object when given a dictionary and a line containing a match" do
      match = @scanner.find_match(@dict, @doc.line(1), :some_content_type, ContentMatch)
      match.should be_a_kind_of ContentMatch
      match.content.to_s.should == "Frank"
      match.dictionary.should == @dict
      match = @scanner.find_match(@zip_codes, @letter.line(2), :some_content_type, ContentMatch)
      match.should be_a_kind_of Helper::Matchable
      match.content.to_s.should == "65286"
    end

    it "should return nil when given a dictionary and a line that doesn't contain a match" do
      puts "DOC LINE 4: #{@doc.line(4).inspect}"
      @dict.each { |item| puts "ITEM: #{item.inspect} SCORE: #{item.score} INDEX: #{item.index}" }
      @dict.take(4) { |item| item.increment }
      @dict.each { |item| puts "ITEM: #{item.inspect} SCORE: #{item.score} INDEX: #{item.index}" }
      match = @scanner.find_match(@dict, @doc.line(4), :some_content_type, ContentMatch)
      match.should be_nil
    end

    it "should assign a document type on initialization" do
      @scanner.instance_variable_get(:@doc_type).should be_a DocumentType
    end
    
    describe "#scan_for" do
      it "should find all matches of the specified type within a given line" do
        line = @letter.line 2
        city_type = @letter.type.find_type :city
        city_matches = @scanner.scan_for city_type, line
        city_matches.first.content.to_s.should == 'Mount Celebres'
      end
    end

    describe "#scan" do
      before(:each) { @outer_matches = @scanner.scan @letter }

      it "should return all outer section and content matches for a document" do
        @outer_matches.should be_a MatchList
        @outer_matches.size.should == 9
      end

      it "should return all matches in order" do
        @outer_matches.first.content.to_s.should == '3519 Front Street'
        @outer_matches.last.content.to_s.should == 'Powers'
      end
    end
  end
end