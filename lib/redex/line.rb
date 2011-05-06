module Redex
# Represents a single line of a document (typically stored in Redis)
  class Line
    
#   Content of the line
    attr_reader :value

#   Line number (*** 1-based ***)
    attr_reader :number
    
    def initialize document, value, number
      @document = document
      @value = value
      @number = number
    end

#   Retrieve document object lazily
    def document
      @document ||= Document.new(@document_name)
    end

#   Sort by line number
    def <=> other
      self.number <=> other.number
    end

  end
end