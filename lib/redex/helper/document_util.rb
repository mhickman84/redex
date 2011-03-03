module Redex
  module Helper
    module DocumentUtil
#     Set parent section
      def parent=(parent)
        @parent = parent
      end
#     Get parent section
      def parent
        @parent
      end

#     Returns true if the section or content is not nested inside another
      def top_level?
        true unless self.parent
      end
    end
  end
end