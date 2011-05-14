require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
module Redex
  describe Redex do
    include RedexHelper
    before :each do
      define_test_dictionaries
    end

    it "should connect to a redis instance" do
      Redex.db.should be_a Redis
      Redex.db.info.should include "redis_version"
    end

    it "should be configurable" do
      Redex.configure do |config|
        config.load_path = ["/path/to/directory/1", "/path/to/directory/2"]
      end

      Redex.configuration.settings[:load_path].should == ["/path/to/directory/1", "/path/to/directory/2"]
    end

    it "should add a new document to the global document type hash" do
      Redex.define_doc_type :test_doc
      doc_types = Redex.configuration.document_types
      doc_types.size.should == 1
      test_doc = doc_types[:test_doc]
      test_doc.should be_a Redex::DocumentType
      test_doc.name.should == :test_doc
    end

    it "should raise an exception if the doc type's name is not unique" do
      Redex.define_doc_type :test_doc
      lambda { Redex.define_doctype :test_doc }.should raise_error
    end

    it "should allow new document types to be defined" do
      define_test_doc_type

      Redex.document_types.size.should == 1
      doc_type = Redex.document_types[:letter]
      doc_type.name.should == :letter
      doc_type.children.size.should == 3
      doc_type.children[0].children[0].name.should == :street_address
      doc_type.children[0].children[0].dictionary.should be_a Redex::Dictionary
      doc_type.children[1].children[0].name.should == :greeting
      doc_type.children[1].children[0].dictionary.should be_a Redex::Dictionary
      doc_type.children[2].name.should == :last_name
      doc_type.children[2].dictionary.should be_a Redex::Dictionary
    end

    it "should allow new content types to be added to a document type" do
      Redex.define_doc_type :letter do |d|
        d.has_content :last_name, :dictionary => :last_names
      end
      doc_type = Redex.document_types[:letter]
      doc_type.content_types.size.should == 1
      doc_type.content_types.first.name.should == :last_name
    end

    it "should have a list of defined document types" do
      Redex.document_types.all? { |doctype| doctype.should be_a DocumentType }
    end

    it "should have a list of defined dictionaries" do
      Redex.dictionaries.size.should == 6
      Redex.dictionaries.all? { |dictionary| dictionary.should be_a Dictionary }
    end

    it "should allow new dictionaries to be defined" do
      Redex.define_dictionary :businesses do |dict|
        dict << 'Heroku'
      end
      @businesses_dictionary = Dictionary.get(:businesses)
      @businesses_dictionary.should be_a Dictionary
      @businesses_dictionary.size.should == 1
    end
  end
end