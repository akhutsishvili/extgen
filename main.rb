#!/usr/bin/env ruby
require 'yaml'

$script_location = File.dirname(__FILE__)
$project_root = ""
$config = nil

require_relative "#{$script_location}/Utils"
require_relative "#{$script_location}/Store"

# Elements
require_relative "#{$script_location}/elements/Grid"
require_relative "#{$script_location}/elements/Combo"



utils = Utils.new()

# find config file
utils.set_project_root()        # for now this will set global variable $project_root

options = utils.argv_parser
if options[:type] == "combo"
  ComboBox.new(options[:path], options[:options]).create()
end
if options[:type] == "grid"
  Grid.new(options[:path], options[:options]).create()
end
