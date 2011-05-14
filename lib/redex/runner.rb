module Redex
  class Runner
    def self.run
      self.import_dictionaries
      self.import_documents

    end

    def self.import_dictionaries
      Dictionary.import(Redex.configuration.load_path)
    end

    def self.import_documents
      @documents = []
      Redex.document_types.each_pair do |key, doc_type|
        @documents << Document.import(doc_type.load_path, :type => key)
      end
      @documents.flatten!
      @documents.each do |doc|
        Redex.configuration.documents[doc.name.to_sym] = doc
      end
    end
  end
end