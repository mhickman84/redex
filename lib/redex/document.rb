require "redex/helper"
require "redex/document_content"
require "redex/document_section"
module Redex
# Represents a document stored in Redis as a list,
# with each line is stored as a list item
  class Document

    extend Helper::Data
    extend Helper::FileUtil::Import

    include Enumerable
    include Helper::ActsAsParent

#   Prefix used in Redis
    NAMESPACE = :file

#   Unique name for document
    attr_reader :name

#   TODO: DRY up
#   Boolean flag indicating whether or not the document has been parsed
    attr_writer :parsed

#   Number of lines
    attr_reader :number_of_lines

    def initialize name, type
      @name = name
      @type = type
      @parsed = false
      @number_of_lines = Document.db.llen @name
    end

#   Saves a single line or an array of lines to a document (stored in Redis)
    def << line_or_lines
      case line_or_lines
        when String
          add_line line_or_lines
        when Array
          add_lines line_or_lines
        else
          raise "#{line_or_lines} must be a string or an array."
      end
      self
    end

#   Retrieves a single document line from Redis and returns a line object
    def line number
      value = nil
      update do
        value = Document.db.lindex @name, number - 1
      end
      Line.new self, value, number
    end

#   Returns all document lines from Redis and as an array of line objects
#   Returns a range of lines when a range object is supplied
    def lines range=nil
      values = []
      if range
        update { values = Document.db.lrange(@name, range.first - 1, range.last - 1) }
      else
        update { values = Document.db.lrange(@name, 0, @number_of_lines) }
      end
      values.each_with_index.map { |val, index| Line.new(self, val, index + 1) }
    end

#   Performs an atomic update on a document
    def update
      yield self
      @number_of_lines = Document.db.llen @name
    end

#   Take lines from Redis
    def each
      current_line = 1
      update do
        until current_line > @number_of_lines
          index = current_line - 1
          value = Document.db.lrange self.name, index, index
          line = Line.new(self, value[0], current_line)
          yield line
          current_line += 1
        end
      end
    end

#   Name-based equality (name is stored as key in Redis)
    def == other
      self.name == other.name
    end

#   Boolean specifying whether parsing has completed for the document
    def parsed?
      @parsed
    end

#   Types of content found in this doc type
    def contents
      children.select { |child| child.is_a? DocumentContent }
    end

#   Types of sections found in this doc type
    def sections
      children.select { |child| child.is_a? DocumentSection }
    end

    def add_section section
      add_child section
    end

    def add_content content
      add_child content
    end

    def level
      0
    end

    def type
      @type_object ||= DocumentType.get(@type)
    end

    private
    def add_line line
      update do
        Document.db.rpush @name, line
      end
      self
    end

    def add_lines lines
      update do
        lines.each do |line|
          add_line line
        end
      end
      self
    end
  end
end