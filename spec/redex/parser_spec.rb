require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Parser do
    before :each do
      @doc = Document.import(File.expand_path "../../spec/document_files/episodes.txt", File.dirname(__FILE__))
      @dict = Dictionary.import(File.expand_path "../../spec/dictionary_files/cast", File.dirname(__FILE__))
      @parser = Parser.new :letter

    end

    it "should create a match object when given a dictionary and a line containing a match" do
      match = @parser.find_match(@dict, @doc.line(1))
      match.should be_a Match
      match.content.should == "Frank"
      match.dictionary.should == @dict
    end

    it "should return nil when given a dictionary and a line that doesn't contain a match" do
      puts "DOC LINE 4: #{@doc.line(4).inspect}"
      @dict.each { |item| puts "ITEM: #{item.inspect} SCORE: #{item.score} INDEX: #{item.index}" }
      @dict.take(4) {|item| item.increment }
      @dict.each { |item| puts "ITEM: #{item.inspect} SCORE: #{item.score} INDEX: #{item.index}" }
      match = @parser.find_match(@dict, @doc.line(4))
      match.should be_nil
    end

    after :each do
      Document.clear
      Dictionary.clear
    end
  end
end