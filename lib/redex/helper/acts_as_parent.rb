module Redex
  module Helper
    module ActsAsParent
#     Add child
      def add_child child
        child.parent = self
        children << child
      end

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
    end
  end
end