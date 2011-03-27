module Redex
  module Helper
    module Type
#     Adds new section to look for within this section type
      def has_section(name, options={})
        self.children ||= []
        new_section_type = SectionType.new(name)
        new_section_type.parent = self
        yield new_section_type if block_given?
        self.children << new_section_type
      end

#     Adds new content to look for within this section type
      def has_content(name, options={})
        self.children ||= []
        new_content_type = ContentType.new(name)
        new_content_type.parent = self
        if options[:dictionary]
          new_content_type.dictionary = Redex.configuration.dictionaries[options[:dictionary]]
        end
        yield new_content_type if block_given?
        self.children << new_content_type
      end

      alias :starts_with_content :has_content
      alias :ends_with_content :has_content
    end
  end
end
