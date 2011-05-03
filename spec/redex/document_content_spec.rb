require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe  DocumentContent do
    before :each do
      dictionary_path = File.expand_path("spec/dictionary_files/cast")
      doc_path = File.expand_path("spec/document_files/episodes.txt")
      @dict = Redex::Dictionary.import(dictionary_path)
      @doc = Redex::Document.import(doc_path)
      @match = ContentMatch.new(@dict.first, @doc.line(2), :episode_content)
      @content = DocumentContent.new :some_content_type, @doc, 2
    end

    it "should be a top level section the parent is a Document" do
      @content.parent = @doc
      @content.top_level?.should be_true
      @content.parent = DocumentSection.new :some_section_type, @doc, 2..5
      @content.top_level?.should be_false
    end

    describe "DocumentContent#from_match" do
      it "should create a DocumentContent instance of the supplied type from a match" do
        content = DocumentContent.from_match :foo_type, @match
        content.should be_a DocumentContent
        content.document.name.should == 'episodes.txt'
        content.type.should == :foo_type
      end
    end
  end
end