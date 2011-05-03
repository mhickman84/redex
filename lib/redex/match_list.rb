module Redex
  class MatchList

    attr_reader :matches

    def initialize match_array=nil
      @matches = match_array || []
    end

    def method_missing name, *args
      if @matches.respond_to? name
        result = @matches.send name, *args
        return MatchList.new result if result.kind_of?(Array)
        result
      else
        super
      end
    end

    def of_class klass
      match_results = @matches.select { |match| match.class == klass }
      MatchList.new match_results
    end

    def of_type match_type
      match_results = @matches.select { |match| match.type == match_type }
      MatchList.new match_results
    end

    def at_location location
      section_results = @matches.select { |match| match.class == SectionMatch }
      location_results = section_results.select { |match| match.location == location }
      MatchList.new location_results
    end

    def concat(match_list)
      combined_matches = @matches.concat(match_list.matches)
      MatchList.new combined_matches
    end
  end
end