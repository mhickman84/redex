module Redex
  class Parser
    def initialize doc_type
      @doc_type = DocumentType.get(doc_type)
      @scanner = Scanner.new(doc_type)
    end

    def parse document
      matches = @scanner.scan document
      sections = @doc_type.section_types.reduce([]) do |memo, sec_type|
        memo.concat(parse_sections_of_type sec_type.name, matches)
      end
      contents = @doc_type.content_types.reduce([]) do |memo, con_type|
        memo.concat(parse_contents_of_type con_type.name, matches)
      end
      document.add_children sections
      document.add_children contents
      document.parsed = true
      document
    end

    def parse_sections_of_type type, matches
      start_matches = matches.of_type(type).at_location(:start)
      end_matches = matches.of_type(type).at_location(:end)
      sections = []
      until start_matches.empty? || end_matches.empty?
        sections << DocumentSection.from_matches(type, start_matches.shift, end_matches.shift)
      end
      sections
    end

    def parse_contents_of_type type, matches
      type_matches = matches.of_class(ContentMatch).of_type(type)
      contents = []
      until type_matches.empty?
        contents << DocumentContent.from_match(type, type_matches.shift)
      end
      contents
    end
  end
end