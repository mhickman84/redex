require 'nokogiri'
require 'open-uri'
require 'csv'
module Redex
  module Helper
    module FileUtil

      def self.generate(dictionary_name, source_file_or_url, *css_or_xpath)
        lines = []
        if source_file_or_url =~ /.csv$/
          CSV.foreach(source_file_or_url) do |row|
            lines << row[0]
          end
        else
          doc = open_page(source_file_or_url)
          doc.search(*css_or_xpath).each do |node|
            lines << node.content
          end
        end
        raise empty_msg if lines.empty?
        create_file(dictionary_name, lines)
      end

      private

      # Creates file with a line for each item in the supplied array
      def self.create_file(name, lines)
        file_path = File.join(Redex.configuration.write_path, name)
        File.open(file_path, "w") do |f|
          lines.each do |line|
            stripped_line = line.strip
            f.puts stripped_line unless stripped_line.empty?
          end
        end
        puts "Created file #{name} in #{Redex.configuration.write_path}"
        file_path
      end

      # opens url and parses document
      def self.open_page(url)
        Nokogiri.parse(open url)
      end

      def self.empty_msg
        msg = %q{ No items found. Please double check your css or xpath selectors
        and ensure that the site you are trying to reach does not block scripts. }
      end

      module Import
#       Load document(s) from file into Redis
        def import(thing, options={})
          puts "INSIDE import METHOD"
          puts "OPTIONS: #{options.inspect}"
          if File.directory? thing
            add_directory thing, options
          elsif File.file? thing
            add_file thing, options
          else
            raise "#{thing} must be a valid file or directory"
          end
        end

        private
#       Adds files in supplied directory to Redis
        def add_directory(directory, options)
          puts "INSIDE add_directory METHOD"
          puts "OPTIONS: #{options.inspect}"
          docs = []
          Dir.foreach(directory) do |file|
            file_path = File.join(File.expand_path(directory), file)
            docs << add_file(file_path, options) unless File.directory? file_path
          end
          docs
        end

#       Adds file to Redis (as a list)
        def add_file(path_to_file, options)
          puts "INSIDE add_file METHOD"
          puts "OPTIONS: #{options.inspect}"
          name = options[:name] || File.basename(path_to_file)
          if options[:type]
            redis_collection = new name, options[:type]
          else
            redis_collection = new name
          end
          
          IO.foreach path_to_file do |line|
            redis_collection << line
          end
          redis_collection
        end
      end
    end
  end
end