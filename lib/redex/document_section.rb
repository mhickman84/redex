module Redex
  class DocumentSection
    include Helper::ActsAsParent
    include Helper::ActsAsChild

#   The document containing this section
    attr_reader :document

#   TODO: DRY up
#   Boolean flag indicating whether or not the document has been parsed
    attr_writer :parsed

    def initialize type, document, line_numbers
      @type_name = type
      @document = document
      @line_numbers = line_numbers
    end

#   Array of lines that the section contains
    def lines
      @document.lines @line_numbers
    end

    def self.from_matches type, start_match, end_match
      line_numbers = Range.new start_match.line.number, end_match.line.number
      DocumentSection.new type, start_match.document, line_numbers
    end

#   Types of content found in this doc type
    def contents
      children.select { |child| child.is_a? DocumentContent }
    end

#   Types of sections found in this doc type
    def sections
      children.select { |child| child.is_a? DocumentSection }
    end

    def add_section section
      add_child section
    end

    def add_content content
      add_child content
    end
    
#   Boolean specifying whether parsing has completed for the document
    def parsed?
      @parsed
    end

    def type
      puts "DOCUMENT: #{document.inspect}"
      puts "DOCUMENT TYPE: #{document.type.inspect}"
      @doc_type = document.type
      @type ||= @doc_type.find_type @type_name
    end
  end
end