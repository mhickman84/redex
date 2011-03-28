module Redex
# Represents a dictionary match found within a document
  class Match

    FLAGS = [
      :content,
      :start_section,
      :end_section
    ]

#   Dictionary item that was matched
    attr_reader :dictionary_item
#   Line that was matched
    attr_reader :line
#   Flag(s) associated with this match
    attr_reader :flags

    extend Helper::Data

#   Increment score of dictionary item when match is created
    def initialize(dict_item, line)
      @dictionary_item = dict_item
      @line = line
      @dictionary_item.increment
    end

#   Retrieve related dictionary by its key
    def dictionary
      @dictionary ||= Dictionary.new(@dictionary_item.key)
    end

#   Retrieve matched document
    def document
      @line.document
    end

    def add_flag(flag)
      raise ArgumentError("Invalid type: #{flag}") unless FLAGS.include?(flag)
      @flags ||= []
      @flags << flag unless @flags.include? flag
    end
    
#   Retrieve content matched
    def content
      @content ||= @dictionary_item.match(@line)
    end
  end
end