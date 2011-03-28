module Redex
  module Helper
    module ActsAsParent
#     Add child
      def add_child(child)
        @children ||= []
        @children << child
      end
#     Get children
      def children
        @children
      end

      def parent?
        true if self.children
      end
    end
  end
end