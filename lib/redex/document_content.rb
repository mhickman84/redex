module Redex
  class DocumentContent
    include Helper::ActsAsChild

#   The document containing this content
    attr_reader :document

    def initialize type, document, line_numbers
      @type_name = type
      @document = document
      @line_numbers = line_numbers
    end

    def self.from_match type, match
      DocumentContent.new(type, match.document, match.line.number)
    end

    def type
      puts "DOCUMENT: #{document.inspect}"
      puts "DOCUMENT TYPE: #{document.type.inspect}"
      @doc_type = document.type
      @type ||= @doc_type.find_type @type_name
    end
  end
end