require_relative "../Utils"
require_relative "Element"

class ComboBox < Element
  
  def initialize(path, options)
    @path = path
    @options = options
    utils = Utils.new
    element_alias = utils.path_to_alias path
    @code = [
      "Ext.define('#{$config["project_name"]}.view.#{path}', {",
      "    fieldLabel: '',",
      "    extend: 'Ext.form.ComboBox',",
      "    alias: 'widget.#{element_alias}',",
      "    name: '',"
    ]

    self.create_store()
    self.create_constructor()

    @code.push "})"

    self
  end
  
end
