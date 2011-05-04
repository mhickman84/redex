module Redex
  class DocumentContent
    include Helper::ActsAsChild

#   Type of content (e.g. header, footer)
    attr_reader :type

#   The document containing this content
    attr_reader :document

    def initialize type, document, line_numbers
      @type = type
      @document = document
      @line_numbers = line_numbers
    end

    def self.from_match type, match
      DocumentContent.new(type, match.document, match.line.number)
    end
  end
end