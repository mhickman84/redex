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

#   Accepts a unique name
    def initialize(name)
      @name = name
      yield self if block_given?
    end
  end
end