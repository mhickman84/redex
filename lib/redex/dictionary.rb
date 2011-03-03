module Redex
  class Dictionary

    extend Redex::DataHelper

    NAMESPACE = :regex

    def self.add_item(set_name, value)
      db.zadd set_name, 0, value
    end

    def self.get_item(set_name, value)
      db.zadd set_name, 0, value
    end
    
    private
    def self.add_file(path_to_file)

    end
  end
end