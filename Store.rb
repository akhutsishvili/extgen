require_relative "Utils"
require_relative "Model"

class Store
  @store_definition = nil
  @model_definition = nil
  @path = nil
  @code = nil
  def initialize(path, options)

    @path = path
    @store_definition = "#{$config["project_name"]}.store.#{path}"
    @model_definition = "'Ext.data.Model'"

    if options.include? "-m"
      model_instance = Model.new(path, options)
      model_instance.create()
      @model_definition = model_instance.get_model_definition
    end

    @code = [
      "Ext.define('#{@store_definition}', {",
      "    extend: 'Ext.data.Store',",
      "    model:  Ext.create(#{@model_definition}),",
      "    proxy: {",
      "        type: 'ajax',"
    ]

    # url param
    url = Utils.new().options_equality_parser(options)["-url"] or ''

    # params as json
    if options.include? "-pas"
      @code.push "        paramsAsJson: true,"
    end
    
    @code.push [
      "        url: '#{url}',",
      "        reader: {",
      "            type: 'json'",
      "        }",
      "    }",
      "})"
    ]
    @code.flatten
    self
  end

  def get_definition
    @store_definition
    self
  end

  def output
    puts @code
    self
  end
  
  def create
    Utils.new().generate(@path, "store", @code)
    self
  end
end
