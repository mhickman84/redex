require File.expand_path('../spec_helper', File.dirname(__FILE__))

module Redex
  describe Runner do

    it "should load all dictionary files in the load directory and save them in the config object" do
      Redex.configuration.load_path = File.expand_path "../../spec/dictionary_files/", File.dirname(__FILE__)
      Runner.import_dictionaries
      Redex.configuration.dictionaries.size.should == 4
      Redex.configuration.dictionaries[:cast].should be_a Dictionary
      Redex.configuration.dictionaries[:cast].size.should == 5
    end

    it "should load all document files in the search directory and save them in the config object" do
      Redex.configuration.search_path = File.expand_path "../../spec/document_files", File.dirname(__FILE__)
      Runner.import_documents
      Redex.configuration.documents.size.should == 4
    end

    after :each do
      Dictionary.db.flushdb
    end
  end
end