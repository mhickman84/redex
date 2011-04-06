module Redex
  module Helper
    module ActsAsChild
#     Set parent
      def parent=(parent)
        @parent = parent
      end

#     Get parent
      def parent
        @parent
      end

#     Returns true if the section or content is not nested inside another
      def top_level?
        true unless self.parent && !self.parent.is_a?(DocumentType)
      end
    end
  end
end