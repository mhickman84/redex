require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Dictionary do
    before :each do
      @dictionary_1 = Dictionary.new("items")
      @dictionary_2 = Dictionary.new("more_items")
      @dictionary_1 << "item"
      @dictionary_1 << "other_item"
      @dictionary_2 << "foo"
    end

    it "should connect to a redis instance" do
      Dictionary.db.should be_a Redis::Namespace
      Dictionary.db.info.should include "redis_version"
    end

    it "should add a dictionary item prefixed with 'dict'" do
      @dictionary_1.items.size.should == 2
      @dictionary_1.items[0].should == "item"
      @dictionary_1.items[1].should == "other_item"
    end

    it "should set the score to 0 for new items" do
      @dictionary_1.items.each { |i| Dictionary.db.zcard(i).should == 0 }
    end

    it "should add an item for each line in a dictionary file" do
      file_path = File.expand_path("spec/dictionary_files/cast")
      @dictionary_from_file = Dictionary.import(file_path)
      items = @dictionary_from_file.items
      items.size.should == 5
      items.should include "Charlie"
      items.should include "Mac"
    end

    it "should remove extra white space and newline characters when adding an item" do
      file_path = File.expand_path("spec/dictionary_files/two")
      @two = Dictionary.import(file_path)
      @two.items.should include "one"
    end

    it "should ignore empty lines when adding a dictionary file" do
      file_path = File.expand_path("spec/dictionary_files/two")
      dictionary = Dictionary.import(file_path)
      dictionary.items.size.should == 5
    end

    it "should delete all items from the database" do
      Redex.db.set "nonfile", "foo"
      Redex.db.keys("dict*").size.should == 2
      Dictionary.clear
      Redex.db.keys("dict*").size.should == 0
      Redex.db.keys("*").size.should == 1
    end

    it "should add all files in a directory when given a directory" do
      directory = File.expand_path("spec/dictionary_files")
      Dictionary.import(directory)
      dictionary_1 = Dictionary.new("cast")
      dictionary_2 = Dictionary.new("two")
      puts "DICTIONARY 1: #{dictionary_1.items.inspect}"
      puts "DICTIONARY 2: #{dictionary_2.items.inspect}"
      dictionary_1.items.size.should == 5
      dictionary_2.items.size.should == 5
      dictionary_1.items.should include "Mac"
      dictionary_2.items.should include "five"
    end

    it "should return the number of items in the dictionary" do
      @dictionary_1.size.should == 2
    end

    it "should iterate through dictionary items" do
      @dictionary_1.each { |item| puts "VALUE: #{item.value}"}
    end

    it "should be enumerable" do
      @dictionary_1.take(1) { |item| puts item }
    end

    it "should raise an error if the item passed is not a string or array" do
      lambda {
        @dictionary_1 << 1
      }.should raise_error
    end

    it "should be equal to another dictionary with the same name" do
      dictionary_1 = Dictionary.new("uno")
      dictionary_2 = Dictionary.new("dos")
      dictionary_3 = Dictionary.new("uno")

      dictionary_1.should == dictionary_1
      dictionary_1.should == dictionary_3
      dictionary_1.should_not == dictionary_2
    end

    it "should retrieve a dictionary from the configuration object by name" do
      Redex.configuration.dictionaries[:cast] = Dictionary.new("cast")
      Dictionary.get(:cast).should be_a Dictionary
      Dictionary.get(:cast).name.should == "cast"
    end

    after :each do
      Dictionary.db.flushdb
    end
  end
end