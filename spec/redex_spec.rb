require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Redex do
  it "should connect to a redis instance" do
    Redex.db.should be_a Redis
    Redex.db.info.should include "redis_version"
  end

  it "should be configurable" do
    Redex.configure do |config|
      config.load_path = ["/path/to/directory/1", "/path/to/directory/2"]
      config.search_path = ["/path/to/directory/3", "/path/to/directory/4"]
    end

    Redex.configuration.settings[:load_path].should == ["/path/to/directory/1", "/path/to/directory/2"]
    Redex.configuration.settings[:search_path].should == ["/path/to/directory/3", "/path/to/directory/4"]
  end

  it "should add a new document to the global document type hash" do
    Redex.define_doctype :test_doc
    doc_types = Redex.configuration.document_types
    doc_types.size.should == 1
    test_doc = doc_types[:test_doc]
    test_doc.should be_a Redex::DocumentType
    test_doc.name.should == :test_doc
  end

  it "should raise an exception if the doc type's name is not unique" do
    Redex.define_doctype :test_doc
    Redex.configuration.document_types.size.should == 1
    lambda { Redex.define_doctype :test_doc }.should raise_error
    Redex.configuration.document_types.size.should == 1
  end

  it "should allow new document types to be defined" do
    Redex.define_doctype :letter do |d|
      d.has_section :return_address do |s|
        s.starts_with :dictionary => :start_return_address
        s.has_content :city, :dictionary => :cities
        s.has_content :state, :dictionary => :states
        s.has_content :zip_code, :dictionary => :zip_codes
        s.ends_with :dictionary => :end_return_address
      end
      d.add_section :inside_address do |s|
        s.starts_with :street_address, :dictionary => :street_addresses
        s.has_content :city, :dictionary => :cities
        s.has_content :state, :dictionary => :states
        s.has_content :zip_code, :dictionary => :zip_codes
        s.ends_with :send_date, :dictionary => :dates
      end
      d.add_section :salutation do |s|
        s.starts_with :greeting, :dictionary => :greetings
        s.ends_with :first_name, :dictionary => :first_names
      end
    end

    Redex.document_types.size.should == 1
    doc_type = Redex.document_types.first
    doc_type.name.should == :letter
    doc_type.sections.size.should == 3
    doc_type.sections[0]
    doc_type.sections[1]
    doc_type.sections[2]
  end

  it "should have a list of defined document types" do
    Redex.document_types.all? { |doctype| doctype.should be_a DocumentType }
  end

  after :each do
    Redex.configuration.document_types = {}
  end
end