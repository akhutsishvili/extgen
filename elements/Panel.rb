require_relative "../Utils"
require_relative "Element"

class Panel < Element

  def initialize(path, options)
    super
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

    if @options.include? "-s"
      store = Store.new(@path, @options)
      store.create()
      @code.push("    store: {xclass: '#{store.get_definition()}'},")
    end

    # create constructor if -c option is present is present
    self.create_constructor()

    @code.push "})"
    
    self
  end


end
