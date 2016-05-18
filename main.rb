#!/usr/bin/env ruby
require 'yaml'

$script_location = File.dirname(__FILE__)
$project_root = ""
$config = nil

require_relative "#{$script_location}/Utils"
require_relative "#{$script_location}/Generator"
require_relative "#{$script_location}/Script"

u = Utils.new()

# find config file
u.set_project_root()        # for now this will set global variable $project_root
params = u.parse_argv
Generator.new(params[:tpl], params[:path], params[:options]).generate().create()
