module Redex
  class Runner
    def self.import_dictionaries
      @dictionaries = Dictionary.import(Redex.configuration.load_path)
      @dictionaries.each do |dict|
        Redex.configuration.dictionaries[dict.name.to_sym] = dict
      end
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