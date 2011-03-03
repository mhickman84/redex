module Redex
  class Runner
    def self.import_dictionaries
      @dictionaries = Dictionary.import(Redex.configuration.load_path)
      @dictionaries.each do |dict|
        Redex.configuration.dictionaries[dict.name.to_sym] = dict
      end
    end
  end
end