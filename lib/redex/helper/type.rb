module Redex
  module Helper
    module Type
#     Adds new section to look for within this section type
      def has_section(name, options={})
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
          new_content_type.dictionary = Redex.configuration.dictionaries[options[:dictionary]]
        end
        yield new_content_type if block_given?
        add_child new_content_type
      end
    end
  end
end
