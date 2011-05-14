module Redex
  module RedexHelper
    def define_test_dictionaries
      @street_addresses = Dictionary.new("street_addresses")
      @cities = Dictionary.new("cities")
      @states = Dictionary.new("states")
      @zip_codes = Dictionary.new("zip_codes")
      @greetings = Dictionary.new("greetings")
      @last_names = Dictionary.new("last_names")

      @street_addresses << ['^\d+\s.+\sRoad$', '^\d+\s.+\sStreet$', '^\d+\s.+\sAvenue$', '^\d+\s.+\sLane$', '^\d+\s.+\sPlaza$']
      @cities << ['Durham', 'Chapel Hill', 'Mount Celebres', 'Las Vegas', 'Industrial Point']
      @states << ['VA', 'CA', 'NC']
      @zip_codes << ['27514', '27708', '22903', '68534', '65286']
      @greetings << ['^Dear.+,', '^Dear.+:']
      @last_names << ['Powers', 'Johnson', 'Smith', 'Davis']
    end

    def define_test_doc_type
      Redex.define_doc_type :letter do |d|
        d.has_section :address do |s|
          s.starts_with_content :street_address, :dictionary => :street_addresses
          s.has_content :city, :dictionary => :cities
          s.has_content :state, :dictionary => :states
          s.ends_with_content :zip_code, :dictionary => :zip_codes
        end
        d.has_section :salutation do |s|
          s.starts_and_ends_with_content :greeting, :dictionary => :greetings
        end
        d.has_content :last_name, :dictionary => :last_names
      end
    end
  end
end