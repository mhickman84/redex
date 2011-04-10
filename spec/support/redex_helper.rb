module Redex
  module RedexHelper
    def add_dictionaries
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

      Redex.configuration.dictionaries[:street_addresses] = @street_addresses
      Redex.configuration.dictionaries[:cities] = @cities
      Redex.configuration.dictionaries[:states] = @states
      Redex.configuration.dictionaries[:zip_codes] = @zip_codes
      Redex.configuration.dictionaries[:greetings] = @greetings
      Redex.configuration.dictionaries[:last_names] = @last_names

      Redex.define_doc_type :letter do |d|
        d.has_section :return_address do |s|
          s.starts_with_content :street_address, :dictionary => :street_addresses
          s.has_content :city, :dictionary => :cities
          s.has_content :state, :dictionary => :states
          s.ends_with_content :zip_code, :dictionary => :zip_codes
        end
        d.has_section :salutation do |s|
          s.starts_with_content :greeting, :dictionary => :greetings
        end
        d.has_content :last_name, :dictionary => :last_names
      end
    end

    def remove_dictionaries
      Redex.configuration.dictionaries = {}
      Redex.configuration.document_types = {}
    end
  end
end