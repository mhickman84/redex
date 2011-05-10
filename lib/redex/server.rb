require 'rubygems'
require 'sinatra'
require 'redex'
require 'json'
module Redex
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path __FILE__)
    set :public, "#{dir}/server/public"

    get "/" do
      File.read(File.join "#{dir}/server/public", 'app.html')
    end

    get "/navItems" do
      content_type :json
      [
          {:text => "Import Data", :name => "import"},
          {:text => "Dictionaries", :name => "dictionaries"},
          {:text => "Parse Documents", :name => "documents"}
      ].to_json
    end

    get "/pages/import" do
      content_type :json
      {:header => "Import"}.to_json
    end
  end
end