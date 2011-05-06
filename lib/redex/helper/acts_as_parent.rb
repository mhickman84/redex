module Redex
  module Helper
    module ActsAsParent
      attr_accessor :depth

#     Add child
      def add_child child
        child.parent = self
        update_depth child.level
        children << child
      end

#     Add array of children
      def add_children children
        children.each { |child| add_child child }
      end

#     Get children
      def children
        @children ||= []
      end

#     Check parent status
      def parent?
        true unless children.empty?
      end

#    Types of content that may occur in this section
      def content_types
        type.children.select { |child| child.class == ContentType }
      end

#    Types of sections that may occur in this section
      def section_types
        type.children.select { |child| child.class == SectionType }
      end

      def update_depth number
        @depth = number if number > depth
      end

      def depth
        @depth ||= 0
      end

#     Depth-first traversal of all children
      def traverse obj=self, &block
        case
          when obj.respond_to?(:parent?) && obj.respond_to?(:child?)
            block.call obj
            obj.children.each { |c| traverse(c, &block) }
          when obj.respond_to?(:parent?)
            obj.children.each { |c| traverse(c, &block) }
          when obj.respond_to?(:child?)
            block.call obj
        end
      end

      def children_at_level level
        children = []
        traverse do |child|
          children << child if child.level == level
        end
        children
      end
    end
  end
end