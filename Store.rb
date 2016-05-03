require_relative "Utils"
require_relative "Model"

class Store

  def create(path, params)
    utils = Utils.new
    store_path = "#{$config["project_name"]}.store.#{path}"
    model_path = "'Ext.data.Model'"
    
    if params.include? "-m"
      model_path = Model.new().create(path, params)
    end

    code = [
      "Ext.define('#{store_path}') {",
      "    extend: 'Ext.data.Store',",
      "    model:  Ext.create(#{model_path}),",
      "    proxy: {",
      "        type: 'ajax',",
      "        url: 'rest/',",
      "        reader: {",
      "            type: 'json'",
      "        }",
      "    }",
      "})"
    ]
    utils.generate(path, "store", code)

    store_path
  end
end
