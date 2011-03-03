module Redex
# Represents a dictionary match found within a document
  class Match
#   Dictionary item that was matched
    attr_reader :dictionary_item
#   Line that was matched
    attr_reader :line

    extend Helper::Data

#   Increment score of dictionary item when match is created
    def initialize(dict_item, line)
      @dictionary_item = dict_item
      @line = line
      @dictionary_item.increment
    end

#   Retrieve related dictionary by its key
    def dictionary
      Dictionary.new(@dictionary_item.key)
    end

#   Retrieve document that the match is in
    def document
      @line.document
    end
    
#   Retrieve content matched
    def content
      @content ||= @dictionary_item.match(@line)
    end
  end
end