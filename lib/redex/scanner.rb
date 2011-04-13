module Redex
  class Scanner

#   Accepts a document type (as a symbol)
    def initialize(doc_type)
      @doc_type = DocumentType.get(doc_type)
    end

    def outer_section_types
      @doc_type.section_types.select do |sec_type|
        sec_type.top_level?
      end
    end

    def outer_content_types
      @doc_type.content_types.select do |type|
        type.top_level?
      end
    end

    def scan_outer_sections(line)
      matches = []
      outer_section_types.each do |sec_type|
        if sec_type.start_dictionary
          matches << find_match(sec_type.start_dictionary, line) do |match|
            match.belongs_to = sec_type.name
            match.type = :start_section
          end
        end
        if sec_type.end_dictionary
          matches << find_match(sec_type.end_dictionary, line) do |match|
            match.belongs_to = sec_type.name
            match.type = :end_section
          end
        end
      end
      matches.compact
    end

    def scan_outer_contents(line)
      matches = []
      outer_content_types.each do |con_type|
        puts "CONTENT TYPE: #{con_type.inspect}"
        matches << find_match(con_type.dictionary, line) do |match|
          match.belongs_to = con_type.name
          match.type = :content
        end
      end
      matches.compact
    end

#   Finds matches for outer sections and contents within
#   the supplied document or section.
    def scan(doc_or_section)
      matches = []
      doc_or_section.lines.each do |line|
        matches.concat scan_outer_sections(line)
        matches.concat scan_outer_contents(line)
      end
      matches.sort
    end

#   Searches a line for dictionary terms
#   Stops searching once a match is found and returns a match object
#   Returns nil if no match is found
#   Increments the score of the corresponding dictionary item when a match is created
    def find_match(dictionary, line)
      first_match = dictionary.detect do |item|
        item.match?(line)
      end
      if first_match
        match = Match.new(first_match, line)
        puts "MATCH FOUND: #{match.inspect}"
        yield match if block_given?
        match
      else
        nil
      end
    end

    def get_section_type(name, document)
      DocumentType.get(document.type).section_types.select {
          |sec_type| sec_type.name == name
      }.first
    end
  end
end