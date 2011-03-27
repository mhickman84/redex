require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Runner do

    before :each do
      Redex.define_doc_type(:letter) do |d|
        d.load_path = File.expand_path "../../spec/document_files/letters/", File.dirname(__FILE__)
      end
      Runner.import_documents
    end

    it "should load all dictionary files in the load directory and save them in the config object" do
      Redex.configuration.load_path = File.expand_path "../../spec/dictionary_files/", File.dirname(__FILE__)
      Runner.import_dictionaries
      Redex.configuration.dictionaries.size.should == 4
      Redex.configuration.dictionaries[:cast].should be_a Dictionary
      Redex.configuration.dictionaries[:cast].size.should == 5
    end

    it "should load all document files of each type" do
      Redex.configuration.documents.size.should == 2
      puts "DOCUMENTS: #{Redex.configuration.documents.inspect}"
      Redex.configuration.documents.values.all? { |doc| doc.type.should == :letter }
    end

    after :each do
      Redex.configuration.document_types = {}
      Dictionary.db.flushdb
    end
  end
end