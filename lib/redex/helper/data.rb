module Redex
  module DataHelper
    def clear
      db.keys.each { |key| db.del key }
    end

    def db
      if const_defined?(:NAMESPACE)
        @redis ||= Redis::Namespace.new(const_get(:NAMESPACE), :redis => Redex.db)
      else
        @redis ||= Redis.new
      end
    end
  end
end