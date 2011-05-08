module Redex
  class Parser
    def initialize doc_type
      @doc_type = DocumentType.get(doc_type)
      @scanner = Scanner.new(doc_type)
    end

    def parse document
      parse_entity document
      puts "DEPTH: #{document.depth}"
      level = 1
      loop do
        children = document.children_at_level level
        break if children.empty? || children.nil?
        children.each do |child|
          next unless child.respond_to? :children
          parse_entity child if child.respond_to? :children
        end
        level += 1
      end
      document
    end

    def parse_entity doc_or_section
      puts "PARSING #{doc_or_section.class} : #{doc_or_section.type.name}"
      matches = @scanner.scan doc_or_section
      sections = doc_or_section.section_types.reduce([]) do |memo, sec_type|
        puts "PARSING #{sec_type.class} #{sec_type.name}"
        memo.concat(parse_sections_of_type sec_type.name, matches)
      end
      contents = doc_or_section.content_types.reduce([]) do |memo, con_type|
        puts "PARSING #{con_type.class} #{con_type.name}"
        memo.concat(parse_contents_of_type con_type.name, matches)
      end
      doc_or_section.add_children sections
      doc_or_section.add_children contents
      doc_or_section.parsed = true
      doc_or_section
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