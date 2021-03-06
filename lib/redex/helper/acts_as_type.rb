module Redex
  module Helper
    module ActsAsType

      #   Name of the section type (i.e. header, footer)
      attr_reader :name

      def type
        self
      end

#     Adds new section to look for within this section type
      def has_section(name)
        new_section_type = SectionType.new(name)
        new_section_type.parent = self
        yield new_section_type if block_given?
        add_child new_section_type
      end

#     Adds new content to look for within this section type
      def has_content(name, options={})
        new_content_type = ContentType.new(name)
        new_content_type.parent = self
        if options[:dictionary]
          new_content_type.dictionary = Dictionary.get(options[:dictionary])
        end
        yield new_content_type if block_given?
        add_child new_content_type
      end
    end
  end
end