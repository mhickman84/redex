require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe MatchList do
    before :each do
      dictionary_path = File.expand_path("spec/dictionary_files/cast")
      doc_path = File.expand_path("spec/document_files/episodes.txt")

      @dict = Redex::Dictionary.import(dictionary_path)
      @doc = Redex::Document.import(doc_path)

      @mac_item = @dict.items.select { |item| item.value == "Mac" }.first
      @dennis_item = @dict.items.select { |item| item.value == "Dennis" }.first
      @frank_item = @dict.items.select { |item| item.value == "Frank" }.first
      @dee_item = @dict.items.select { |item| item.value == "Dee" }.first

      @first_match = SectionMatch.new(@frank_item, @doc.line(1), :episode_section)
      @first_match.location = :start
      @second_match = ContentMatch.new(@mac_item, @doc.line(2), :episode_content)
      @third_match = ContentMatch.new(@dennis_item, @doc.line(2), :other_content)
      @fourth_match = SectionMatch.new(@dee_item, @doc.line(6), :episode_section)
      @fourth_match.location = :end

      @matches = MatchList.new
      @matches << @first_match
      @matches << @second_match
      @matches << @third_match
      @matches << @fourth_match
    end

    describe "#of_class" do
      before(:each) { @content_matches = @matches.of_class ContentMatch }
      it "should return only matches of the specified class" do
        @content_matches.length.should == 2
        @content_matches.all? { |match| match.should be_a ContentMatch }
      end

      it "should return a MatchList object" do
        @content_matches.should be_a MatchList
      end
    end

    describe "#of_type" do
      before(:each) { @episode_content_matches = @matches.of_type :episode_content }
      it "should return only matches for the specified content type" do
        @episode_content_matches.size.should == 1
        @episode_content_matches.first.type.should == :episode_content
      end

      it "should return a MatchList object" do
        @episode_content_matches.should be_a MatchList
      end
    end

    describe "#at_location" do
      before(:each) { @start_matches = @matches.at_location :start }
      it "should return matches signaling the start of a section" do
        @start_matches.size.should == 1
        @start_matches.first.location.should == :start
      end

      it "should return a MatchList object" do
        @start_matches.should be_a MatchList
      end
    end
  end
end