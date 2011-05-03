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
        puts "DOCUMENTS: #{@documents.inspect}"
        Redex.configuration.documents[doc.name.to_sym] = doc
      end
    end

#   Find matches for the specified document type
    def self.find_matches(doc_type)
      parser = Parser.new
      @matches = []
      docs = Redex.configuration.documents.select { |doc| doc.type == doc_type }
      docs.each do |doc|
        doc.lines.each do |line|
          DocumentType.get(doc_type)
          match = parser.find_match(line)
          @matches << match if match
        end
      end
      @matches
    end

  end
end