require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Match do
    before :each do
      dictionary_path = File.expand_path("spec/dictionary_files/cast")
      doc_path = File.expand_path("spec/document_files/episodes.txt")
      @dict = Redex::Dictionary.import(dictionary_path)
      @doc = Redex::Document.import(doc_path)
      @match = Match.new(@dict.first, @doc.line(2))
    end

    it "should be associated with a line and a dictionary item" do
      @match.dictionary_item.should be_a Redex::DictionaryItem
      @match.line.should be_a Redex::Line
    end

    it "should contain a string containing the matched content" do
      @match.content.should be_a MatchData
      @match.content.to_s.should == "Mac"
    end

    it "should reference a dictionary" do
      @match.dictionary.should be_a Redex::Dictionary
      @match.dictionary.name.should == "cast"
    end

    it "should reference a document" do
      @match.document.should be_a Redex::Document
      @match.document.name.should == "episodes.txt"
    end

    it "should increment the score of a dictionary item when confirmed" do
      @match.confirm
      @dict.first.score.should == 1
    end

    it "should ignore subsequent calls to confirm" do
      @match.confirm
      @match.confirm
      @dict.first.score.should == 1
    end

    it "should sort by line number in descending order" do
      mac_item = @dict.items.select { |item| item.value == "Mac" }.first
      charlie_item = @dict.items.select { |item| item.value == "Charlie" }.first
      first_match = Match.new(mac_item, @doc.line(2))
      second_match = Match.new(charlie_item, @doc.line(5))

      first_match.<=>(second_match).should == 1
      second_match.<=>(first_match).should == -1
      second_match.<=>(second_match).should == 0
    end

    it "should sort by the character index of the match if the line numbers are equal" do
      mac_item = @dict.items.select { |item| item.value == "Mac" }.first
      dennis_item = @dict.items.select { |item| item.value == "Dennis" }.first

      first_match = Match.new(mac_item, @doc.line(2))
      second_match = Match.new(dennis_item, @doc.line(2))
      first_match.<=>(second_match).should == 1
      second_match.<=>(first_match).should == -1
      first_match.<=>(first_match).should == 0
    end

    after(:each) { Redex.db.flushdb }
  end
end