module Redex
  class Configuration
#   Add global configuration option
    def self.define_setting(setting, options={})
      define_method("#{setting}=") { |value| settings[setting] = value }
      define_method(setting) { settings.has_key?(setting) ? settings[setting] : options[:default] }
    end

#   TODO: Add Redis Connection as setting
#   Path where dictionaries are located
    define_setting :load_path, :default => []
#   Path where new dictionary files are written
    define_setting :write_path
#   Global hash of user-defined document types
    define_setting :document_types, :default => {}
#   Global hash of documents
    define_setting :documents, :default => {}

#   Returns the global hash of settings
    def settings
      @settings ||= {}
    end
  end
end