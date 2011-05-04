module Redex
  class MatchList

    def initialize target=nil
      @target = target
    end

    def target
      @target ||= []
    end

    def of_class klass
      results = target.select { |match| match.is_a? klass }
      MatchList.new results
    end

    def of_type match_type
      results = target.select { |match| match.type == match_type }
      MatchList.new results
    end

    def at_location location
      section_results = target.select { |match| match.is_a? SectionMatch }
      location_results = section_results.select { |match| match.location == location }
      MatchList.new location_results
    end

    def to_ary
      target
    end

    private
    
    def method_missing(method, *args, &block)
      result = target.send(method, *args, &block)
      case result
        when Array
          MatchList.new result
        else
          result
      end
    end
  end
end