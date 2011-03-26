module Redex
  class Runner
    def self.import_dictionaries
      @dictionaries = Dictionary.import(Redex.configuration.load_path)
      @dictionaries.each do |dict|
        Redex.configuration.dictionaries[dict.name.to_sym] = dict
      end
    end

    def self.import_documents
      @documents = Document.import(Redex.configuration.search_path)
      @documents.each do |doc|
        Redex.configuration.documents[doc.name.to_sym] = doc
      end
    end
  end
end