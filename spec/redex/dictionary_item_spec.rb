require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe DictionaryItem do

    before :each do
      file_path = File.expand_path("spec/dictionary_files/cast")
      @dict = Dictionary.import(file_path)
      @item = DictionaryItem.new(@dict, "Frank")
      @item_2 = DictionaryItem.new(@dict, "Mac")
      3.times { @item.increment }
      @dict.items.each { |item| puts item }
      @line = Line.new(Document.new("fake"), "This line contains the name Frank.", 1)
    end

    it "should access an item from a dictionary" do
      @item.value.should == "Frank"
      @item.key.should == "cast"
      @item.score.should == 3
      @item.key.should be_a String
    end

    it "should increment items by 1" do
      @item_2.score.should == 0
      @item_2.increment
      @item_2.score.should == 1
    end

    it "should be comparable based on the score" do
      @item.<=>(@item_2).should == 1
      @item_2.<=>(@item).should == -1
      @item_2.<=>(@item_2).should == 0
    end

    it "should return a regular expression" do
      @item.to_regexp.should be_a Regexp
    end

    it "should return a match object containing the matched string" do
      @item.match(@line).should be_a MatchData
      @item.match(@line).to_s.should == "Frank"
    end

    it "should return false if no match is found" do
      line_2 = Line.new(Document.new("fake"), "This line doesn't contain a match.", 1)
      @item.match?(line_2).should == false
    end

    it "should return the index of the item" do
      pending
    end

    it "should return true if a match is found" do
      @item.match?(@line).should == true
    end

    after :each do
      Dictionary.db.flushdb
    end
  end
end