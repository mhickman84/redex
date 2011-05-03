module Redex
  class Parser
    def initialize(doc_type)
      @doc_type = DocumentType.get(doc_type)
    end

    def parse_sections_for_owner(type, matches)
      start_matches = matches.of_type :start_section
      end_matches = matches.
      sections
    end

    def parse_contents(matches)
      
    end
  end
end