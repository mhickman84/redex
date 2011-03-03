require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Hit do
    before :each do
      dictionary_path = File.expand_path("spec/dictionary_files/cast.txt")
      doc_path = File.expand_path("spec/test_files/episodes.txt")
      @dict = Dictionary.import(dictionary_path)
      @doc = Document.import(doc_path)
      @hit = Hit.new(@dict.first, @doc.line(2), "Mac")
    end

    it "should be associated with a line and a dictionary item" do
      @hit.dictionary_item.should be_a DictionaryItem
      @hit.line.should be_a Line
    end

    it "should contain a string containing the matched content" do
      @hit.content.should be_a String
      @hit.content.should == "Mac"
    end

    it "should reference a dictionary" do
      @hit.dictionary.should be_a Dictionary
      @hit.dictionary.name.should == "cast"
    end

    it "should reference a document" do
      @hit.document.should be_a Document
      @hit.document.name.should == "episodes"
    end

  end
end