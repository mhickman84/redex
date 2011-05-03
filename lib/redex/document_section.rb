module Redex
  class DocumentSection
    include Helper::ActsAsParent
    include Helper::ActsAsChild

#   Type of section (e.g. header, footer)
    attr_reader :type

#   The document containing this section
    attr_reader :document

    def initialize type, document, line_numbers
      @type = type
      @document = document
      @line_numbers = line_numbers
    end

    def starts_with options
      self.has_section
    end

#   Array of lines that the section contains
    def lines
      @document.lines @line_numbers
    end

    def self.from_matches type, start_match, end_match
      line_numbers = Range.new start_match.line.number, end_match.line.number
      new type, start_match.document, line_numbers
    end
  end
end