#!/usr/bin/env ruby
$script_location = File.dirname(__FILE__)
$project_root = ""
require 'yaml'
$config = nil

# find config file
execute_dir = Dir.pwd
search_dir = execute_dir.split("/")
begin
  search_dir = search_dir.join("/")
  found_files = Dir.glob("#{search_dir}/extgen_config.yml")
  if found_files.length == 1
    $config = YAML.load_file("#{search_dir}/extgen_config.yml")
    $project_root = search_dir
    break
  else
    search_dir = search_dir.split("/")[0...-1]
  end
end while search_dir.length > 1

# Report config not found error
if $config.nil?
  puts "Error: Can not find extgen_config.yml config file."
  abort
end

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
