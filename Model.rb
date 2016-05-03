require_relative "Utils"

class Model
  def create(path, params)
    utils = Utils.new
    model_path = "'#{$config["project_name"]}.model.#{path}'"
    code = [
      "Ext.define(#{model_path}, {",
      "    extend: 'Ext.data.Model',",
      "    fields: [{",
      "        name: 'id',",
      "        type: 'int'",
      "    }]",
      "})"
    ]
    utils.generate(path, "model", code)
    model_path
  end
end
