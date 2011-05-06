require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Document do
    before(:each) do
      @doc = Document.new("some_file", :term_paper)
      @other_doc = Document.new("other_file", :essay)

      @doc << "Random line of text."
      @doc << "Next line of text."
      @doc << "Another line of text."
      @other_doc << "Random line of text"
    end

    it "should connect to a redis instance" do
      Document.db.should be_a Redis::Namespace
      Document.db.info.should include "redis_version"
    end

    it "should add a line of text to redis prefixed with 'file'" do
      Redex.db.lrange("file:some_file", 0, 0)[0].should == "Random line of text."
      Redex.db.lrange("file:some_file", 1, 1)[0].should == "Next line of text."
    end

    it "should return a line of text when given a line number" do
      @doc.line(1).value.should == "Random line of text."
    end

    it "should return all lines of text for a file when range is omitted" do
      @doc.lines.size.should == 3
      @doc.lines[0].value.should == "Random line of text."
      @doc.lines[2].value.should == "Another line of text."
    end

    it "should return multiple lines of text when given a file name and a range" do
      @doc.lines(1..2).size.should == 2
      @doc.lines(1..2).first.value.should == "Random line of text."
      @doc.lines(1..2).last.value.should == "Next line of text."
    end

    it "should add an array of strings" do
      doc = Document.new("array_doc", :array_doc)
      doc << ["Line one.", "Line two.", "Line three."]
      lines = doc.lines 1..3
      lines.size.should == 3
      lines[0].value.should == "Line one."
      lines[1].value.should == "Line two."
      lines[2].value.should == "Line three."
    end

    it "should add all lines in a file when given a file path" do
      file_path = File.expand_path("spec/document_files/test.txt")
      Document.import(file_path, :type => :some_doc_type)
      lines = Document.new("test.txt", :some_doc_type).lines
      puts "LINES: #{lines.inspect}"
      lines.size.should == 3
      lines[0].value.should == "First line of file\n"
      lines[1].value.should == "Second line of file\n"
      lines[2].value.should == "Third line of file"
    end

    it "should add all files in a directory when given a directory" do
      directory = File.expand_path("spec/document_files")
      puts directory
      Document.import(directory, :type => :some_doc_type)
      file_lines = Document.new("test.txt", :test_doc).lines
      file_2_lines = Document.new("test2.txt", :test_doc).lines
      file_lines.size.should == 3
      file_2_lines.size.should == 5
      file_lines[0].value.should == "First line of file\n"
      file_lines[2].value.should == "Third line of file"
      file_2_lines[0].value.should == "One line.\n"
      file_2_lines[4].value.should == "Five lines."
    end

    it "should delete all files from the database" do
      Redex.db.set "nonfile", "foo"
      Redex.db.keys("file*").size.should == 2
      Document.clear
      Redex.db.keys("file*").size.should == 0
      Redex.db.keys("*").size.should == 1
    end

    it "should iterate through lines" do
      @doc.each { |item| puts "VALUE: #{item.value}" }
    end

    it "should be equal to another dictionary with the same name" do
      doc_1 = Document.new("uno", :some_doc_type)
      doc_2 = Document.new("dos", :some_doc_type)
      doc_3 = Document.new("uno", :some_doc_type)

      doc_1.should == doc_1
      doc_1.should == doc_3
      doc_1.should_not == doc_2
    end

    it "should not be flagged as 'parsed' at initialization" do
      @doc.parsed?.should be_false
    end

  end
end