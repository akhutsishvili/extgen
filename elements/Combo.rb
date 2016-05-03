require_relative "../Utils"
require_relative "../Model"
require_relative "../Store"

class ComboBox
  @@path = ""
  @@params = ""
  @@constructor_code = [
    "    constructor: function (cfg) {",
    "       cfg = cfg || {}",
    "       var me = this",
    "    }"
  ]
  def initialize(path, params)
    @@path = path
    @@params = params
    utils = Utils.new
    element_alias = utils.path_to_alias path
    @code = [
      "Ext.define('#{$config["project_name"]}.view.#{path}') {",
      "    fieldLabel: '',",
      "    extend: 'Ext.form.ComboBox',",
      "    alias: 'widget.#{element_alias}'",
      "    name: ''"
    ]

    if @@params.include? "-s"
      store_path = Store.new().create(@@path, @@params)
      @code.push("    store: {xclass: '#{store_path}'},")
    end

    if @@params.include? "-c"
      @code.push @@constructor_code
    end
    @code.push "})"
    self
  end

  def create()
    Utils.new().generate(@@path, "view", @code)
    self
  end
end
