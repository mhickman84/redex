#!/usr/bin/env ruby
$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require 'redex/server'

# Start web ui
run Redex::Server.new