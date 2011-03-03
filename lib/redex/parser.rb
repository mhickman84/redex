module Redex
  class Parser
#   Searches a line for dictionary terms
#   Stops searching once a match is found and returns a match object
    def find_match(dictionary, line)
      exit_item = nil
      dictionary.take_while do |item|
        puts "ITEM: #{item.inspect}"
        exit_item = item
        !item.match?(line)
      end
      puts "MATCHED ITEM: #{exit_item.inspect}"
      if exit_item.match?(line)
        Match.new(exit_item, line)
      else
        nil
      end
    end
  end
end