module Redex
# Type of document to be parsed
  class DocumentType

    include Helper::ActsAsParent

#   Unique name of the type of document containing the content to be extracted (letter, resume, etc).
    attr_reader :name
    
#   Path where this type of document is stored
    attr_accessor :load_path

#   Accepts a unique name
    def initialize(name)
      @name = name
      yield self if block_given?
    end

#   Returns the document type object associated with the supplied name
    def self.get(name)
      Redex.document_types[name] || raise("Document type #{name} has not been defined")
    end

#   Types of content found in this doc type
    def content_types
      self.children.select { |child| child.class == ContentType }
    end

#   Types of sections found in this doc type
    def section_types
      self.children.select { |child| child.class == SectionType }
    end
  end
end