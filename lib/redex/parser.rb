module Redex
  class Parser
    def initialize(doc_type)
      @doc_type = DocumentType.get(doc_type)
    end

    def parse_sections_of_type type, matches
      start_matches = matches.of_type(type).at_location(:start)
      end_matches = matches.of_type(type).at_location(:end)
      sections = []
      until start_matches.empty? || end_matches.empty?
        DocumentSection.from_matches type, start_matches.shift, end_matches.shift
      end
      sections
    end

    def parse_contents_of_type type, matches
      matches = matches.of_class(ContentMatch).of_type(type)
      contents = []
      until matches.empty?
        contents << DocumentContent.from_match(type, matches.shift)
      end
      contents
    end
  end
end