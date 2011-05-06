module Redex
  module Helper
    module ActsAsChild

      attr_accessor :parent

#     Returns true if the section or content is not nested inside another
      def top_level?
        self.parent.is_a?(Document) || self.parent.is_a?(DocumentType) ? true : false
      end

      def child?
        true unless parent.nil?
      end

      def siblings
        parent.children.reject { |c| c == self }
      end

      def level
        if parent
          parent.level + 1
        else
          0
        end
      end

      def find_root obj=self
        if obj.respond_to?(:parent) && obj.parent
          find_root(obj.parent)
        else
          obj
        end
      end
    end
  end
end