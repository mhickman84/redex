require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Redex do
  before :each do
    @start_return_address = Redex::Dictionary.new("start_return_address")
    @cities = Redex::Dictionary.new("cities")
    @states = Redex::Dictionary.new("states")
    @zip_codes = Redex::Dictionary.new("zip_codes")
    @end_return_address = Redex::Dictionary.new("end_return_address")
    @greetings = Redex::Dictionary.new("greetings")
    @first_names = Redex::Dictionary.new("first_names")

    Redex.configuration.dictionaries[:start_return_address] = @start_return_address
    Redex.configuration.dictionaries[:cities] = @cities
    Redex.configuration.dictionaries[:states] = @states
    Redex.configuration.dictionaries[:zip_codes] = @zip_codes
    Redex.configuration.dictionaries[:end_return_address] = @end_return_address
    Redex.configuration.dictionaries[:greetings] = @greetings
    Redex.configuration.dictionaries[:first_names] = @first_names
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
    Redex.configuration.document_types.size.should == 1
    lambda { Redex.define_doctype :test_doc }.should raise_error
    Redex.configuration.document_types.size.should == 1
  end

  it "should allow new document types to be defined" do
    Redex.define_doc_type :letter do |d|
      d.has_section :return_address do |s|
        s.starts_with :dictionary => :start_return_address
        s.has_content :city, :dictionary => :cities
        s.has_content :state, :dictionary => :states
        s.has_content :zip_code, :dictionary => :zip_codes
        s.ends_with :dictionary => :end_return_address
      end
      d.has_section :salutation do |s|
        s.starts_with_content :greeting, :dictionary => :greetings
        s.ends_with_content :first_name, :dictionary => :first_names
      end
    end

    Redex.document_types.size.should == 1
    doc_type = Redex.document_types[:letter]
    doc_type.name.should == :letter
    doc_type.children.size.should == 2
    doc_type.children[0].children[0].name.should == :city
    doc_type.children[0].children[0].dictionary.should be_a Redex::Dictionary
    doc_type.children[1].children[0].name.should == :greeting
    doc_type.children[1].children[0].dictionary.should be_a Redex::Dictionary
  end

  it "should allow new content types to be added to a document type" do
    Redex.define_doc_type :letter do |d|
      d.has_content :first_name, :dictionary => :first_names
    end
    doc_type = Redex.document_types[:letter]
    doc_type.content_types.size.should == 1
    doc_type.content_types.first.name.should == :first_name
  end

  it "should have a list of defined document types" do
    Redex.document_types.all? { |doctype| doctype.should be_a DocumentType }
  end

end