module Redex
# Reads from / writes to a sorted set of words or regular expressions
  class Dictionary

    extend Helper::Data
    extend Helper::FileUtil::Import
    include Enumerable
    
    NAMESPACE = :dict

    attr_reader :name

    def initialize(name)
      @name = name
    end

#   Retrieve a dictionary by name (takes a symbol)
    def self.get(name)
      if Redex.configuration.dictionaries[name]
        Redex.configuration.dictionaries[name]
      else
        raise "Dictionary #{name} not found"
      end
    end

#   Add an item or an array of items to a dictionary
#   Returns the dictionary object
    def <<(item_or_items)
      case item_or_items
        when String
          add_item item_or_items
        when Array
          add_items item_or_items
        else
          raise ArgumentError("#{item_or_items} must be a string or an array.")
      end
      self
    end

    def items
      values = Dictionary.db.zrangebyscore(@name, "-inf", "+inf")
      values.map { |val| DictionaryItem.new(self, val) }
    end

    def [](index)
      item_value = Dictionary.db.zrange(@name, index, index).first
      DictionaryItem.new(self, item_value)
    end

    def size
      Dictionary.db.zcount("#{NAMESPACE}:#{@name}", "-inf", "+inf").to_i
    end

    def update
      Document.db.multi do
        yield self
      end
    end

#   fetch dictionary items one by one from Redis
    def each
      current_index = size - 1
      while current_index >= 0
        value = Dictionary.db.zrange self.name, current_index, current_index
        item = DictionaryItem.new(self, value[0])
        yield item if block_given?
        current_index -= 1
      end
    end
    
#   Name-based equality
    def ==(other)
      self.name == other.name
    end

    private

    def add_item(item)
      sanitized_value = item.strip.chomp.sub("\t", "")
      Dictionary.db.zadd @name, 0, sanitized_value unless sanitized_value.empty?
    end

    def add_items(items)
      update do |dict|
        items.each do |item|
          add_item item
        end
      end
    end
  end
end