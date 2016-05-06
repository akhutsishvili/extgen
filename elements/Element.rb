require_relative "../Utils"

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
  
  def create()
    Utils.new().generate(@path, "view", @code)
    self
  end
end
