require 'rubygems'
require 'sinatra'
require 'redex'
require 'json'
require 'nokogiri'
module Redex
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path __FILE__)
    set :public, "#{dir}/server/public"
    set :views, "#{dir}/server/views"
    enable :sessions
#   to enable sessions with shotgun plugin
    set :session_secret, "code monkey"

    helpers do
      def nav_items
        {:dictionaries => [:index],
         :documents => [:index],
         :import_data => [:from_web, :from_file]}
      end

      def current_section
        nav_items.keys.detect { |item| request.path.include? url_for(item) }
      end

      def current_item
        if request.path == url_for(current_section)
          current_section
        elsif request.path.include? url_for(current_section)
          nav_items[current_section].detect do |item|
            request.path == url_for(item)
          end
        end
      end

      def text_for nav_item
        if nav_items.keys.include? nav_item
          item_text = nav_item.to_s
        elsif nav_items.values.flatten.include? nav_item
          item_text = "#{nav_items.key(nav_item).to_s}_#{nav_item.to_s}"
        end
        item_text.to_s.split('_').map do |s|
          s.capitalize
        end.join(' ')
      end

      def header_text
        if (text_for(current_section) == text_for(current_item))
          text_for current_section
        else
          "#{text_for current_section} | #{text_for current_item}"
        end
      end

      def url_for nav_item
        if nav_items.keys.include? nav_item
          "/#{nav_item.to_s}"
        elsif nav_items.values.flatten.include? nav_item
          nav_item_key = nil
          nav_items.each_pair { |key, value| nav_item_key = key if value.include? nav_item }
          "/#{nav_item_key.to_s}/#{nav_item.to_s}"
        end
      end

      def partial template, local_vars={}
        erb template.to_sym, {:layout => false}, local_vars
      end
    end

    before do
      unless session['initialized']
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
        session['initialized'] = true
      end
      @dictionaries = Dictionary.get_all
    end

    get "/" do
      redirect url_for :dictionaries
    end

    get "/import_data" do
      erb :import_data, :layout => true
    end

    get "/import_data/from_file" do
      erb :import_from_file, :layout => true
    end

    get "/import_data/from_web" do
      erb :import_from_web, :layout => true
    end

    get "/import_data/from_web/:dictionary_name" do
      @selected_dictionary = Dictionary.get params[:dictionary_name].intern
      erb :import_from_web, :layout => true
    end

    post "/import_data/from_web/:dictionary_name/preview" do
      @selected_dictionary = Dictionary.get params[:dictionary_name]
      url = params[:url]
      selector = params[:selector]
      doc = Nokogiri.parse(open url)
      session['preview_data'] = doc.search(selector).map do |node|
        node.content unless node.content.nil?
      end
      redirect "/import_data/from_web/#{@selected_dictionary.name}/preview"
    end

    get "/import_data/from_web/:dictionary_name/preview" do
      @selected_dictionary = Dictionary.get params[:dictionary_name]
      @preview_data = session['preview_data']
      puts @preview_data.inspect
      erb :import_from_web, :layout => true
    end

    get "/dictionaries" do
      erb :dictionaries, :layout => true
    end

    get "/dictionaries/:name" do
      @selected_dictionary = Dictionary.get params[:name]
      erb :dictionaries, :layout => true
    end

    get "/documents" do
      erb :documents, :layout => true
    end
  end
end