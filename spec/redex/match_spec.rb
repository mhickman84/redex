require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Match do
    before :each do
      dictionary_path = File.expand_path("spec/dictionary_files/cast")
      doc_path = File.expand_path("spec/document_files/episodes.txt")
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
      @match.document.name.should == "episodes.txt"
    end

    it "should increment the score of a dictionary item when created" do
      @dict.first.score.should == 1
    end

    it "should be able to add multiple flags" do
      @match.add_flag :content
      @match.add_flag :end_section
      @match.flags.size.should == 2
      @match.flags.should include :content, :end_section
    end

    it "should not be able to add duplicate flags" do
      @match.add_flag :content
      @match.add_flag :content
      @match.flags.size.should == 1
      @match.flags.first.should == :content
    end

    it "should raise an error for invalid flags" do
      lambda { @match.add_flag :invalid_flag }.should raise_error
    end

    after(:each) { Redex.db.flushdb }
  end
end