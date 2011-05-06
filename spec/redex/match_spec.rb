require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe ContentMatch do
    before :each do
      dictionary_path = File.expand_path("spec/dictionary_files/cast")
      doc_path = File.expand_path("spec/document_files/episodes.txt")
      @dict = Redex::Dictionary.import(dictionary_path)
      @doc = Redex::Document.import(doc_path, :type => :episode_doc)
      @match = ContentMatch.new(@dict.first, @doc.line(2), :episode_content)
    end

    it "should be associated with a line and a dictionary item" do
      @match.dictionary_item.should be_a Redex::DictionaryItem
      @match.line.should be_a Redex::Line
    end

    it "should contain a string with the matched content" do
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

    describe "#confirm" do
      it "should increment the score of a dictionary item when confirmed" do
        @match.confirm
        @dict.first.score.should == 1
      end

      it "should ignore subsequent calls to confirm" do
        @match.confirm
        @match.confirm
        @dict.first.score.should == 1
      end
    end

    describe "<=>" do
      before :each do
        @mac_item = @dict.items.select { |item| item.value == "Mac" }.first
        @charlie_item = @dict.items.select { |item| item.value == "Charlie" }.first
        @dennis_item = @dict.items.select { |item| item.value == "Dennis" }.first
        @frank_item = @dict.items.select { |item| item.value == "Frank" }.first
        @dee_item = @dict.items.select { |item| item.value == "Dee" }.first
      end

      it "should compare by line number in ascending order" do
        first_match = ContentMatch.new(@mac_item, @doc.line(2), :episode_content)
        second_match = ContentMatch.new(@charlie_item, @doc.line(5), :episode_content)

        first_match.<=>(second_match).should == -1
        second_match.<=>(first_match).should == 1
        second_match.<=>(second_match).should == 0
      end

      it "should compare by the character index of the match if the line numbers are equal" do
        first_match = ContentMatch.new(@mac_item, @doc.line(2), :episode_content)
        second_match = ContentMatch.new(@dennis_item, @doc.line(2), :episode_content)
        first_match.<=>(second_match).should == -1
        second_match.<=>(first_match).should == 1
        first_match.<=>(first_match).should == 0
      end

      it "should sort matches by line number then index in ascending order" do
        first_match = ContentMatch.new(@frank_item, @doc.line(1), :episode_content)
        second_match = ContentMatch.new(@mac_item, @doc.line(2), :episode_content)
        third_match = ContentMatch.new(@dennis_item, @doc.line(2), :episode_content)
        fourth_match = ContentMatch.new(@charlie_item, @doc.line(5), :episode_content)
        fifth_match = ContentMatch.new(@dee_item, @doc.line(6), :episode_content)
        matches = []
        matches << second_match << third_match << fifth_match << fourth_match << first_match
        matches.sort!
        matches[0].content.to_s.should == "Frank"
        matches[1].content.to_s.should == "Mac"
        matches[2].content.to_s.should == "Dennis"
        matches[3].content.to_s.should == "Charlie"
        matches[4].content.to_s.should == "Dee"
      end
    end
  end
end