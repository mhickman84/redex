module Redex
  class ContentType
    include Helper::ActsAsChild
    include Helper::ActsAsType


#   List of matching regular expressions
    attr_accessor :dictionary

    def initialize(name)
      @name = name
    end
  end
end