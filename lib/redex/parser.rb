module Redex
  class Parser

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

    def parse_outer_section_types(line)
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

    def parse_outer_content_types(line)
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

    def parse(document)

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

    def match_section(section_type_name, document)
      matches = []
      start_match = match_section_start(section_type_name, document)
      puts "START MATCH: #{start_match.inspect}"
      matches << start_match unless start_match.nil?
      end_match = match_section_end(section_type_name, document)
      puts "END MATCH: #{end_match.inspect}"
      matches << end_match unless end_match.nil?
    end

    def match_section_start(section_type_name, document_or_section)
      match = nil
      section_type = get_section_type(section_type_name, document_or_section)
      document_or_section.lines.each do |line|
        match = find_match(section_type.end_dictionary, line)
        if match
          @last_line = line.number
          break
        end
      end
      match
    end

    def match_section_end(section_type_name, document_or_section)
      match = nil
      section_type = get_section_type(section_type_name, document_or_section)
      puts "LAST LINE -- #{@last_line}"
      puts "NUM LINES -- #{document_or_section.number_of_lines}"
      total_lines = document_or_section.number_of_lines
      document_or_section.lines(@last_line..total_lines).each do |line|
        puts "LINE #{line.number}: #{line.inspect}"
        match = find_match(section_type.end_dictionary, line)
        if match
          @last_line = line.number
          break
        end
      end
      match
    end

    def get_section_type(name, document)
      DocumentType.get(document.type).section_types.select {
          |sec_type| sec_type.name == name
      }.first
    end
  end
end