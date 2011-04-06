module Redex
  class DictionaryItem
#   Key of the dictionary containing this item
    attr_reader :key
#   Value of dictionary item (string)
    attr_reader :value

#   Accepts a dictionary object or name
    def initialize(dictionary, value)
      @key = dictionary.name || dictionary
      @value = value
    end

#   Get the item index from Redis
    def index
      Dictionary.db.zrank(@key, @value).to_i
    end

#   Retrieve the score from Redis
    def score
      Dictionary.db.zscore(@key, @value).to_i
    end

#   Bump up the score in Redis
    def increment
      Dictionary.db.zincrby @key, 1, @value
    end

#   Convert value to a basic regular expression
    def to_regexp
      Regexp.new(@value)
    end

#   Convert value to regex and return the first capture
    def match(line)
      regex = self.to_regexp
      regex.match(line.value)
    end

#   Return true (match found) or false (no match found)
    def match?(line)
      return false unless self.to_regexp.match(line.value)
      true
    end

    def dictionary
      Dictionary.new(@key)
    end
    
#   compare based on index
    def <=>(other)
      self.index <=> other.index
    end
  end
end