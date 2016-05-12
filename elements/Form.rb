require_relative "../Utils"
require_relative "Element"

class Form < Element
  
  def initialize(path, options)
    super
    @code = [
      "Ext.define('#{$config["project_name"]}.view.#{path}', {",
      "    title: '',",
      "    extend: 'Ext.form.Panel',",
      "    alias: 'widget.#{@element_alias}',",
      "    bodyPadding: 10,",
      "    border: false,"
    ]
    self.create_layout()
    @code.push(create_fields options)
    self.create_constructor()
    @code.push "})"
    self
  end

  def create_fields(options)
    fn_param = Utils.new().options_equality_parser(options)["-fn"]
    field_number = fn_param.to_i
    fields_code = []
    if fn_param and field_number > 0
      template = [
        "{",
        "    xtype: 'textfield',",
        "    name: 'replaceMe'",
        "},"
      ]
      field_number.times do fields_code.push template end
      "    items: [" + fields_code.join("\n").chomp(",") + "],"
    else
      "    items: [],"
    end
  end

end
