require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe RegexLoader do
    before(:each) do
      RegexLoader.add_item "items", "item"
      RegexLoader.add_item "items", "other_item"
      RegexLoader.add_item "more_items", "foo"
      @items = Redex.db.zrangebyscore("regex:items", "-inf", "+inf")
    end
    
    it "should connect to a redis instance" do
      Dictionary.db.should be_a Redis::Namespace
      Dictionary.db.info.should include "redis_version"
    end

    it "should add a dictionary item prefixed with 'regex'" do
      @items.size.should == 2
      @items[0].should == "item"
      @items[1].should == "other_item"
    end

    it "should set the score to 0 for new items" do
      @items.each { |i| Dictionary.db.zcard(i).should == 0 }
    end

    it "should add an item for each line in a dictionary file" do
      file_path = File.expand_path("spec/dictionary_files/one.txt")
      Dictionary.load(file_path)
      items = Dictionary.get_items("one")
      items.size.should == 5
      items.first.should include "Mac"
      items.last.should include "Charlie"
    end

    it "should delete all items from the database" do
      Redex.db.set "nonfile", "foo"
      Redex.db.keys("regex*").size.should == 2
      Dictionary.clear
      Redex.db.keys("regex*").size.should == 0
      Redex.db.keys("*").size.should == 1
    end

    after(:each) do
      Dictionary.db.flushdb
    end
  end
end