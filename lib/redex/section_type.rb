module Redex
# Represents the types of sections that can occur within
# a document or another section
  class SectionType
    include Helper::Type
    include Helper::ActsAsParent
    include Helper::ActsAsChild
#   Name of the section type (i.e. header, footer)
    attr_reader :name

#   Dictionary terms signaling the start of the section
    attr_reader :start_dictionary

#   Dictionary terms signaling the end of the section
    attr_reader :end_dictionary
    

    def initialize(name)
      @name = name
    end

#   Set start dictionary
    def starts_with(options)
      @start_dictionary = Dictionary.get(options[:dictionary])
    end
    
#   Set end dictionary
    def ends_with(options)
      @end_dictionary = Dictionary.get(options[:dictionary])
    end
    
  end
end