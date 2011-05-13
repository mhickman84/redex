require 'rubygems'
require 'sinatra'
require 'redex'
require 'json'
module Redex
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path __FILE__)
    set :public, "#{dir}/server/public"
    set :views, "#{dir}/server/views"


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
        else
          raise "Error: Nav item: #{nav_item.to_s} not found."
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

    get "/" do
      erb :home, :layout => true
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

    get "/dictionaries" do
      erb :dictionaries, :layout => true
    end

    get "/documents" do
      erb :documents, :layout => true
    end
  end
end