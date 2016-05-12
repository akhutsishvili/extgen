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
require_relative "#{$script_location}/elements/Panel"



utils = Utils.new()

# find config file
utils.set_project_root()        # for now this will set global variable $project_root

options = utils.argv_parser
e = nil                         # element to generate
if options[:type] == "combo"
  e = ComboBox.new(options[:path], options[:options])
elsif options[:type] == "grid"
  e = Grid.new(options[:path], options[:options])
elsif options[:type] == "store"
  e = Store.new(options[:path], options[:options])
elsif options[:type] == "model"
  e = Model.new(options[:path], options[:options])
elsif options[:type] == "panel"
  e = Panel.new(options[:path], options[:options])
else
  puts "Error: Can not create type #{options[:type]}"
  abort
end

if options[:options].include? "-o"
  e.output
elsif
  e.create
  e.output_path_and_alias
end
