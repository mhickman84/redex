module Redex
  class ContentMatch
    include Helper::Matchable
  end

  class SectionMatch
    include Helper::Matchable
#   Start or end of section
    attr_accessor :location
  end
end