module Redex
# Type of document to be parsed
  class DocumentType

    include Helper::ActsAsParent
    include Helper::ActsAsType

#   Unique name of the type of document containing the content to be extracted (letter, resume, etc).
    attr_reader :name

#   Path where this type of document is stored
    attr_accessor :load_path

#   Accepts a unique name
    def initialize name
      @name = name
      yield self if block_given?
    end

    def level
      0
    end

#   Retrieves a child section or content type by name (takes a symbol)
    def find_type child_type_name
      type_match = nil
      traverse do |type|
        type_match = type if type.name == child_type_name
      end
      type_match
    end

#   Returns the document type object associated with the supplied name
    def self.get name
      Redex.document_types[name] || raise("Document type: #{name} has not been defined")
    end
  end
end