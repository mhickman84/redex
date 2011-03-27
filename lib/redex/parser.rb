module Redex
  class Parser
#   List of match objects
    attr_reader :matches
#   Type of document to parse
    attr_reader :doc_type

    def initialize(doc_type)
      @doc_type = DocumentType.get(doc_type)

    end

#   Searches a line for dictionary terms
#   Stops searching once a match is found and returns a match object
#   Returns nil if no match is found
#   Increments the score of the corresponding dictionary item when a match is created
    def find_match(dictionary, line)
      exit_item = nil
      dictionary.take_while do |item|
        puts "ITEM: #{item.inspect}"
        exit_item = item
        !item.match?(line)
      end
      puts "MATCHED ITEM: #{exit_item.inspect}"
      if exit_item.match?(line)
        Match.new(exit_item, line)
      else
        nil
      end
    end

    def parse_outer_sections(document)
      self.doc_type.
      document.lines.each do |line|
        
      end
    end

  end
end