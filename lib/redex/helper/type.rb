module Redex
  module Helper
    module Type
#     Adds new section to look for within this section type
      def has_section(name, options={})
        @section_types ||= []
        new_section = SectionType.new(name)
        yield new_section if block_given?
        @section_types << new_section
      end

#     Adds new content to look for within this section type
      def has_content(name, options={})
        @content_types ||= []
        new_content = ContentType.new(name)
        if options[:dictionary]
          new_content.dictionary = Redex.configuration.dictionaries[options[:dictionary]]
        end
        yield new_content if block_given?
        @content_types << new_content
      end

      alias :starts_with_content :has_content
      alias :ends_with_content :has_content
    end
  end
end
