module Redex
# Represents the types of sections that can occur within
# a document or another section
  class SectionType
    include Helper::ActsAsParent
    include Helper::ActsAsChild
    include Helper::ActsAsType

#   Dictionary terms signaling the start of the section
    attr_reader :start_dictionary

#   Dictionary terms signaling the end of the section
    attr_reader :end_dictionary


    def initialize name
      @name = name
    end

#   Set start dictionary
    def starts_with options
      @start_dictionary = Dictionary.get options[:dictionary]
    end

#   Set end dictionary
    def ends_with options
      @end_dictionary = Dictionary.get options[:dictionary]
    end

    def starts_and_ends_with_content name, options={}
      starts_with options
      ends_with options
      has_content name, options
    end

    def starts_with_content name, options={}
      starts_with options
      has_content name, options
    end

    def ends_with_content name, options={}
      ends_with options
      has_content name, options
    end
  end
end