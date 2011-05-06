require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe DocumentSection do
    include RedexHelper
    before :each do
      define_test_dictionaries
      define_test_doc_type
      file_path = File.expand_path("spec/document_files/episodes.txt")
      @doc = Document.import(file_path, :type => :letter)
      @section = DocumentSection.new(:address, @doc, 3..4)
    end

    it "should belong to a document" do
      @section.document.should be_a Document
      @section.document.name.should == "episodes.txt"
    end

    it "should be a top level section the parent is a document" do
      @section.parent = @doc
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

    it "should create a section when given a start and end match" do
      dictionary_path = File.expand_path("spec/dictionary_files/cast")
      doc_path = File.expand_path("spec/document_files/episodes.txt")
      dictionary = Redex::Dictionary.import(dictionary_path)
      document = Redex::Document.import(doc_path, :type => :episode_list)
      mac_item = dictionary.find_item "Mac"
      charlie_item = dictionary.find_item "Charlie"
      start_match = SectionMatch.new(mac_item, document.line(2), :episode_section)
      start_match.location = :start
      end_match = SectionMatch.new(charlie_item, @doc.line(5), :episode_section)
      end_match.location = :end
      section = DocumentSection.from_matches(:type_a, start_match, end_match)
      section.should be_a DocumentSection
      section.lines.size.should == 4
      section.document.name.should == "episodes.txt"
    end

    it "should have a level that is one greater than the level of its parent" do
      @doc.add_child @section
      @doc.level.should == 0
      @section.level.should == 1

      nested_section = DocumentSection.new :type_b, @doc, 5..6
      @section.add_child nested_section
      nested_section.level.should == 2
    end

    it "should point to the root document" do
      @doc.add_child @section
      @section.find_root.should == @doc
    end

    describe "#type" do
      it "should return the SectionType object matching the section's type" do
        @letter_section = DocumentSection.new(:address, @doc, 3..4)
        @section.type.should be_a SectionType
        @section.type.name.should == :address
      end
    end
  end
end