require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe DocumentSection do
    before :each do
      file_path = File.expand_path("spec/document_files/episodes.txt")
      @doc = Document.import(file_path)
      @section = DocumentSection.new(:header_section, @doc, 3..4)
    end

    it "should belong to a document" do
      @section.document.should be_a Document
      @section.document.name.should == "episodes.txt"
    end

    it "should be a top level section if no parent has been assigned" do
      @section.top_level?.should be_true
      @section.parent = DocumentSection.new(:some_section, @doc, 1..2)
      @section.top_level?.should be_false
    end

    it "should reference lines from the parent document" do
      lines = @section.lines
      lines.size.should == 2
      lines.first.value.should == "Dennis Gets Divorced\n"
      lines.last.value.should == "Hundred Dollar Baby\n"
    end

    after :each do
      Document.clear
      Dictionary.clear
    end
  end
end