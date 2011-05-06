module Redex
  class MatchList

    def initialize target=nil
      @target = target
    end

#   Filter by class
    def of_class klass
      results = target.select { |match| match.is_a? klass }
      MatchList.new results
    end

#   Filter by type
    def of_type match_type
      results = target.select { |match| match.type == match_type }
      MatchList.new results
    end

#   Filter by location (:start, :end, etc)
    def at_location location
      section_results = target.select { |match| match.is_a? SectionMatch }
      location_results = section_results.select { |match| match.location == location }
      MatchList.new location_results
    end

#   Convert to array
    def to_ary
      target
    end

    private

    def target
      @target ||= []
    end

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