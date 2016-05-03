#!/usr/bin/env ruby
$script_location = File.dirname(__FILE__)
require 'yaml'
$config = YAML.load_file("#{$script_location}/extgen_config.yml")

require_relative "#{$script_location}/Utils"
require_relative "#{$script_location}/Store"

# Elements
require_relative "#{$script_location}/elements/Grid"
require_relative "#{$script_location}/elements/Combo"

utils = Utils.new()
options = utils.argv_parser
if options[:type] == "combo"
  ComboBox.new(options[:path], options[:options]).create()
end
if options[:type] == "grid"
  Grid.new(options[:path], options[:options]).create()
end
