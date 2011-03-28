module Redex
  class Parser

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
          match.add_flag :start_section
          match.add_flag :content
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
          match.add_flag :end_section
          match.add_flag :content
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


    def parse_content(content_type, document)

    end

    def parse_outer_sections(document)
#      dictionaries = @doc_type.section_types.map { |section_type| section_type. }
      document.lines.each do |line|

      end
    end

  end
end