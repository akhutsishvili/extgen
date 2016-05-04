require_relative "../Utils"
require_relative "../Store"

class Grid
  @@path = nil
  @code = nil
  @@options = nil
  @@constructor_code = [
    "    constructor: function (cfg) {",
    "       cfg = cfg || {}",
    "       var me = this",
    "    }"
  ]
  
  def initialize(path, options)
    @path = path
    @options = options
    utils = Utils.new
    element_alias = utils.path_to_alias path
    @code = [
      "Ext.define('#{$config["project_name"]}.view.#{path}', {",
      "    title: '',",
      "    extend: 'Ext.grid.Panel',",
      "    alias: 'widget.#{element_alias}'",
    ]

    if @options.include? "-s"
      store = Store.new(@path, @options)
      store.create()
      @code.push("    store: {xclass: '#{store.get_definition()}'},")
    end
    
    @code.push(create_fields options)
    if @options.include? "-c"
      @code.push @constructor_code
    end
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
        "    text: '',",
        "    dataIndex: ''",
        "},"
      ]
      field_number.times do fields_code.push template end
      "    fields: [" + fields_code.join("\n").chomp(",") + "],"
    else
      "    fields: [],"
    end
  end

  def create()
    Utils.new().generate(@path, "view", @code)
    self
  end
end
