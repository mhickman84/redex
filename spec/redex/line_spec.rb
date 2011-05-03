require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Line do

    before :each do
      file_path = File.expand_path("spec/document_files/test.txt")
      @doc = Document.import(file_path)
      @doc_line = @doc.line 1
      @doc_line_2 = @doc.line 2
    end

    it "should reference a document" do
      @doc_line_2.value.should == "Second line of file\n"
      @doc_line.document.name.should == "test.txt"
      @doc_line.document.should be_a Document
    end

    it "should be comparable based on the line number (index in redis)" do
      @doc_line_2.<=>(@doc_line).should == 1
      @doc_line.<=>(@doc_line_2).should == -1
      @doc_line.<=>(@doc_line).should == 0
    end
  end
end