module Redex
  module Helper
    module Matchable
#     Dictionary item that was matched
      attr_reader :dictionary_item

#     Line that was matched
      attr_reader :line

#     Content of the match
      attr_reader :content

#     Type of content or section
      attr_reader :type

#     Retrieve related dictionary by its key
      def dictionary
        @dictionary ||= Redex::Dictionary.new(@dictionary_item.key)
      end

      def initialize dict_item, line, type
        @content = dict_item.match line
        raise "Error: no match found for item #{dict_item.value} and line #{line.value}" unless @content
        @dictionary_item = dict_item
        @line = line
        @type = type
      end

#     Retrieve matched document
      def document
        @line.document
      end

#     Increment match only once (ignore subsequent method calls)
      def confirm
        @dictionary_item.increment unless @confirmed
        @confirmed = true
        @confirmed.freeze
      end

#   TODO: MAKE MORE CONCISE
#   sort by line number and then by character index
      def <=>(other)
        case
          when self.line.number < other.line.number
            -1
          when self.line.number > other.line.number
            1
          when self.line.number == other.line.number
            puts "CONTENT BEGINNING: #{self.content.begin(0)}"
            if self.content.begin(0) < other.content.begin(0)
              -1
            elsif self.content.begin(0) > other.content.begin(0)
              1
            else
              0
            end
        end
      end
    end
  end
end