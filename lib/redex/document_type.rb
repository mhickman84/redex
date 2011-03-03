module Redex

  class DocumentType
    attr_reader :name

    def initialize(name)
      @name = name
      yield self
    end

    
  end
end