require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Document do
    before(:each) do
      Document.add_line "some_file", 15, "Random line of text."
      Document.add_line "some_file", 16, "Next line of text."
      Document.add_line "some_file", 17, "Another line of text."
      Document.add_line "other_file", 18, "Other line of text."
    end

    it "should connect to a redis instance" do
      Document.db.should be_a Redis::Namespace
      Document.db.info.should include "redis_version"
    end

    it "should add a line of text to redis prefixed with 'file'" do
      Redex.db.zrangebyscore("file:some_file", 15, 15)[0].should == "Random line of text."
      Redex.db.zrangebyscore("file:some_file", 16, 16)[0].should == "Next line of text."
    end

    it "should return a line of text when given a file name and line number" do
      Document.get_line("some_file", 15).should == "Random line of text."
    end

    it "should return multiple lines of text when given a file name and a range" do
      lines = Document.get_lines("some_file")
      lines.size.should == 3
      lines[0].should == "Random line of text."
      lines[2].should == "Another line of text."
    end

    it "should return all lines of text for a file when range is omitted" do
      lines = Document.get_lines("some_file", 15..16)
      lines.size.should == 2
      lines[0].should == "Random line of text."
      lines[1].should == "Next line of text."
    end

    it "should add an array of strings" do
      Document.add_lines "other_file", ["Line one.", "Line two.", "Line three."]
      lines = Document.get_lines "other_file", 0..2
      lines.size.should == 3
      lines[0].should == "Line one."
      lines[1].should == "Line two."
      lines[2].should == "Line three."
    end

    it "should add all lines in a file when given a file path" do
      file_path = File.expand_path("spec/test_files/test.txt")
      Document.load(file_path)
      lines = Document.get_lines "test"
      lines.size.should == 3
      lines[0].should == "First line of file\n"
      lines[1].should == "Second line of file\n"
      lines[2].should == "Third line of file"
    end

    it "should add all files in a directory when given a directory" do
      directory = File.expand_path("spec/test_files")
      puts directory
      Document.load(directory)
      file_lines = Document.get_lines "test"
      file_2_lines = Document.get_lines "test2"
      file_lines.size.should == 3
      file_2_lines.size.should == 5
      file_lines[0].should == "First line of file\n"
      file_lines[2].should == "Third line of file"
      file_2_lines[0].should == "One line.\n"
      file_2_lines[4].should == "Five lines."
    end

    it "should delete all files from the database" do
      Redex.db.set "nonfile", "foo"
      Redex.db.keys("file*").size.should == 2
      Document.clear
      Redex.db.keys("file*").size.should == 0
      Redex.db.keys("*").size.should == 1
    end

    after(:each) do
      Document.db.flushdb
    end
  end
end