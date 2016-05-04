#!/usr/bin/env ruby
require 'yaml'

$script_location = File.dirname(__FILE__)
$project_root = ""
$config = nil

require_relative "#{$script_location}/Utils"
require_relative "#{$script_location}/Store"
require_relative "#{$script_location}/Model"

# Elements
require_relative "#{$script_location}/elements/Grid"
require_relative "#{$script_location}/elements/Combo"



utils = Utils.new()

# find config file
utils.set_project_root()        # for now this will set global variable $project_root

options = utils.argv_parser
if options[:type] == "combo"
  ComboBox.new(options[:path], options[:options]).create()
elsif options[:type] == "grid"
  Grid.new(options[:path], options[:options]).create()
elsif options[:type] == "store"
  Store.new(options[:path], options[:options]).create()
elsif options[:type] == "model"
  Model.new(options[:path], options[:options]).create()
else
  puts "Error: Can not create type #{options[:type]}"
end
