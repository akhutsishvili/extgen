require_relative "../Utils"
require_relative "../Store"

class Element
  def initialize(path, options)
    @attributes = ['path', 'options', 'code', 'constructor_code']

  end

  def create_constructor
    if @options.include? "-c"
      @code.push [
        "    constructor: function (cfg) {",
        "       cfg = cfg || {}",
        "       var me = this",
        "       me.callParent(arguments)",
        "    }"
      ]
    end
    self
  end

  # create constructor if -c option is present is present
  def create_store
    if @options.include? "-s"
      store = Store.new(@path, @options)
      store.create()
      @code.push("    store: {xclass: '#{store.get_definition()}'},")
    end
    self
  end

  # create layouts attrs if -layout=<type> present and -a or -align for type: align
  def create_layout
    utils = Utils.new()
    eq_params = utils.options_equality_parser(@options)
    attrs = []
    layout = ["    layout : {"]
    if eq_params.include? "-layout"
      attrs.push "        type: '#{eq_params['-layout']}'"
      if @options.include? "-a" or @options.include? "-align"
        attrs.push "        align: 'stretch'"
      end
    end
    
    layout.push(utils.generate_attrs(attrs)).push("    }")
    @code.push layout
  end
  
  def create()
    Utils.new().generate(@path, "view", @code)
    self
  end
end
