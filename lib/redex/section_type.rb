module Redex
# Represents the types of sections that can occur within
# a document or another section
  class SectionType
    include Helper::Type

#   Name of the section type (i.e. header, footer)
    attr_reader :name

#   Dictionary terms signaling the start of the section
    attr_accessor :starts_with

#   Dictionary terms signaling the end of the section
    attr_accessor :ends_with

#   Sections to look for within this section type
    attr_accessor :section_types

#   Contents to look for within this section type
    attr_accessor :content_types

    def initialize(name, options={})
      @name = name
    end
  end
end