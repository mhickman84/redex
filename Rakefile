require 'rubygems'
require 'bundler'
require 'metric_fu'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "redex"
  gem.homepage = "http://github.com/mhickman84/redex"
  gem.license = "MIT"
  gem.summary = %Q{TODO: one-line summary of your gem}
  gem.description = %Q{TODO: longer description of your gem}
  gem.email = "mhickman84@gmail.com"
  gem.authors = ["Mike Hickman"]
  gem.executables = ["redex-web"]
  gem.add_runtime_dependency 'nokogiri', '~> 1.4'
  gem.add_runtime_dependency 'redis-namespace', '~> 0.1'
  gem.add_runtime_dependency 'sinatra', '1.2'
  gem.add_runtime_dependency 'vegas', '~> 0.1.2'
  gem.add_development_dependency 'rspec', '~> 2.5.0'
  gem.add_development_dependency 'bundler', '~> 1.0.10'
  gem.add_development_dependency 'jeweler', '~> 1.5.2'
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "redex #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


require File.expand_path('lib/redex')
namespace :redis do
  desc 'Start redis'
  task :start do
    `~/bin/redis-server ~/.redis/config/redis.conf`
  end

  desc 'Stop redis'
  task :stop do
    sh 'echo "SHUTDOWN" | nc localhost 6379'
  end
end

desc %q{
Create a dictionary file from web content (xml or html).
Writes to the directory specified by Forgery::FileWriter#write_to!
'${GEM_HOME}/lib/forgery/dictionaries' by default (standalone)
'${RAILS_ROOT}/lib/forgery/dictionaries' by default (as a Rails 3 plugin)

Parameters:
:dictionary_name  -- the name of your new dictionary file
:source_url       -- web page containing the data for your dictionary file
:css_or_xpath     -- css or xpath selector(s) to element(s) containing the desired data

Usage:
rake create_dictionary[name_of_file,'http://www.html_or_xml_page.com','li']
}
task :create_dictionary, :dictionary_name, :source_url, :css_or_xpath do |t, args|
  dictionary_name = args[:dictionary_name].to_s || raise("parameter :dictionary_name is required")
  source_url = args[:source_url].to_s || raise("parameter :source_url is required")
  css_or_xpath = args[:css_or_xpath].to_s || raise("parameter :css_or_xpath is required")

  Redex::FileGenerator.generate(dictionary_name, source_url, css_or_xpath)
end
