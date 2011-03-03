module Redex
  module Helper
#   Helper methods related to data access
    module Data
#     Clears all data out of the namespaced instance
      def clear
        db.keys.each { |key| db.del key }
      end

#     Namespaced Redis Instance
      def db
        if const_defined?(:NAMESPACE)
          @redis ||= Redis::Namespace.new(const_get(:NAMESPACE), :redis => Redex.db)
        else
          @redis ||= Redis.new
        end
      end
    end
  end
end