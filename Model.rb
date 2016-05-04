require_relative "Utils"

class Model
  @model_definition = nil
  @code = nil
  @path = nil

  def initialize(path, params)
    @path = path
    @model_definition = "'#{$config["project_name"]}.model.#{path}'"
    @code = [
      "Ext.define(#{@model_definition}, {",
      "    extend: 'Ext.data.Model',",
      "    fields: [{",
      "        name: 'id',",
      "        type: 'int'",
      "    }]",
      "})"
    ] 
    self
  end

  def get_model_definition
    @model_definition
  end
  
  def create
    utils = Utils.new
    utils.generate(@path, "model", @code)
  end
end
