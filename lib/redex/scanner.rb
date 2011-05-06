module Redex
  class Scanner

#   Accepts a document type (as a symbol)
    def initialize doc_type
      @doc_type = DocumentType.get(doc_type)
    end

#   Finds matches for outer sections and contents within
#   the supplied document or section.
    def scan doc_or_section
      matches = MatchList.new
      child_types = doc_or_section.type.children
      doc_or_section.lines.each do |line|
        child_types.each do |type|
          puts "SCANNING LINE #{line.number} for TYPE #{type.name}"
          matches << scan_for(type, line)
        end
      end
      matches.flatten.sort
    end

    def scan_for type, line
      matches = MatchList.new
      case type
        when ContentType
          matches << find_match(type.dictionary, line, type.name, ContentMatch)
        when SectionType
          matches << find_match(type.start_dictionary, line, type.name, SectionMatch) do |match|
            match.location = :start
          end
          matches << find_match(type.end_dictionary, line, type.name, SectionMatch) do |match|
            match.location = :end
          end
      end
      matches.compact
    end

#   Searches a line for dictionary terms
#   Stops searching once a match is found and returns a match object
#   Returns nil if no match is found
#   Increments the score of the corresponding dictionary item when a match is confirmed
    def find_match dictionary, line, type, match_class
      first_match = dictionary.detect do |item|
        item.match? line
      end
      if first_match
        match = match_class.new first_match, line, type
        puts "MATCH FOUND: #{match.inspect}"
        yield match if block_given?
        match
      else
        nil
      end
    end
  end
end