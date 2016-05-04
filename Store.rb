require_relative "Utils"
require_relative "Model"

class Store
  @store_definition = nil
  @model_definition = nil
  @path = nil
  @code = nil
  def initialize(path, params)

    @path = path
    @store_definition = "#{$config["project_name"]}.store.#{path}"
    @model_definition = "'Ext.data.Model'"

    if params.include? "-m"
      model_instance = Model.new(path, params)
      model_instance.create()
      @model_definition = model_instance.get_model_definition
    end

    @code = [
      "Ext.define('#{@store_definition}', {",
      "    extend: 'Ext.data.Store',",
      "    model:  Ext.create(#{@model_definition}),",
      "    proxy: {",
      "        type: 'ajax',",
      "        url: 'rest/',",
      "        reader: {",
      "            type: 'json'",
      "        }",
      "    }",
      "})"
    ]

    self
  end

  def get_definition
    @store_definition
  end
  
  def create
    Utils.new().generate(@path, "store", @code)
    self
  end
end
