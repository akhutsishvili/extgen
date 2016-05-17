require_relative "../Utils"
require_relative "Element"

class ComboBox < Element
  
  def initialize(path, options)
    super
    @code = [
      "Ext.define('#{$config["project_name"]}.view.#{path}', {",
      "    fieldLabel: '',",
      "    extend: 'Ext.form.ComboBox',",
      "    alias: 'widget.#{@element_alias}',",
      "    name: '',"
    ]
    self.generate_colin_code
    self.create_store()
    self.create_constructor()

    @code.push "})"

    self
  end
  
end
