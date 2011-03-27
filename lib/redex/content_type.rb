module Redex
  class ContentType
    include Helper::ActsAsChild

#   Name of the section type (i.e. header, footer)
    attr_reader :name
#   List of matching regular expressions
    attr_accessor :dictionary

    def initialize(name)
      @name = name
    end
  end
end