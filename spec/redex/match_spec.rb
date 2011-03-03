require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Match do
    before :each do
      dictionary_path = File.expand_path("spec/dictionary_files/cast.txt")
      doc_path = File.expand_path("spec/test_files/episodes.txt")
      @dict = Dictionary.import(dictionary_path)
      @doc = Document.import(doc_path)
      @match = Match.new(@dict.first, @doc.line(2))
    end

    it "should be associated with a line and a dictionary item" do
      @match.dictionary_item.should be_a DictionaryItem
      @match.line.should be_a Line
    end

    it "should contain a string containing the matched content" do
      @match.content.should be_a String
      @match.content.should == "Mac"
    end

    it "should reference a dictionary" do
      @match.dictionary.should be_a Dictionary
      @match.dictionary.name.should == "cast"
    end

    it "should reference a document" do
      @match.document.should be_a Document
      @match.document.name.should == "episodes"
    end

  end
end