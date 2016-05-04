require_relative "../Utils"
require_relative "../Store"

class ComboBox
  @path = nil
  @options = nil
  @code = nil
  @constructor_code = [
    "    constructor: function (cfg) {",
    "       cfg = cfg || {}",
    "       var me = this",
    "       me.callParent(arguments)",
    "    }"
  ]
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

    if @options.include? "-s"
      store = Store.new(@path, @options)
      store.create()
      @code.push("    store: {xclass: '#{store.get_definition()}'},")
    end

    if @options.include? "-c"
      @code.push @constructor_code
    end
    @code.push "})"

    self
  end

  def create()
    Utils.new().generate(@path, "view", @code)
    self
  end
end
