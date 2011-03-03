module Redex
  module Document
    class Section
      include Document::Helper

#     Type of section (e.g. header, footer)
      attr_reader :type

#     The parent section (only applies if this section is nested within another)
      attr_accessor :parent

#     The document containing this section
      attr_reader :document

      def initialize(type, document, line_numbers)
        @type = type
        @document = document
        @line_numbers = line_numbers
      end

#     Array of lines that the section contains
      def lines
        @document.lines @line_numbers
      end


    end
  end
end