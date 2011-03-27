require 'redis-namespace'
require 'redex/configuration'
require 'redex/helper'
require 'redex/document'
require 'redex/content_type'
require 'redex/section_type'
require 'redex/document_type'
require 'redex/line'
require 'redex/dictionary_item'
require 'redex/dictionary'
require 'redex/match'
require 'redex/parser'
require 'redex/runner'

module Redex
  extend Helper::Data

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end

  def self.document_types
    configuration.document_types
  end

  def self.define_doc_type(name)
    doc_type = DocumentType.new name
    yield doc_type if block_given?
    if configuration.document_types.keys.include? name
      raise "Doctype #{name} cannot be added because it already exists"
    end
    configuration.document_types[name] = doc_type
  end
end