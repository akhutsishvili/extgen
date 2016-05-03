require 'yaml'
$config = YAML.load_file('extgen_config.yml')

require_relative "Utils"
require_relative "Store"

# Elements
require_relative "elements/Grid"
require_relative "elements/Combo"

utils = Utils.new()
options = utils.argv_parser
if options[:type] == "combo"
  ComboBox.new(options[:path], options[:options]).create()
end
if options[:type] == "grid"
  Grid.new(options[:path], options[:options]).create()
end
