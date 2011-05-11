require 'rubygems'
require 'sinatra'
require 'redex'
require 'json'
module Redex
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path __FILE__)
    set :public, "#{dir}/server/public"
    set :views,  "#{dir}/server/views"

    get "/" do
      erb :home, {:layout => true}
    end

    get "/import" do
      erb :import, {:layout => true}
    end
  end
end