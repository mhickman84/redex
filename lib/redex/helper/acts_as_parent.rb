module Redex
  module Helper
    module ActsAsParent
#     Set children
      def children=(children)
        @children = children
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