module Redex
# Type of document to be parsed
  class DocumentType

    include Helper::Type

#   Unique name of the type of document containing the content to be extracted (letter, resume, etc).
    attr_reader :name
#   Sections to look for within this document type
    attr_reader :section_types
#   Contents to look for within this document type
    attr_reader :content_types
#   Path where this type of document is stored
    attr_accessor :load_path

#   Accepts a unique name
    def initialize(name)
      @name = name
      yield self if block_given?
    end

#   Returns the document type object associated with the supplied name
    def self.get(name)
      Redex.document_types[name]
    end

  end
end