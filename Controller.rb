require_relative "Utils"

class Controller
  @code = nil
  @path = nil

  def initialize(path, params)
    @path = path
    @full_definition = "'#{$config["project_name"]}.controller.#{path}'"
    @code = [
      "Ext.define(#{@full_definition}, {",
      "    extend: 'Ext.app.Controller',",
      "    init: function() {",
      "       var me = this",
      "       me.control({",
      "",
      "       })",
      "    }",
      "})"
    ] 
    self
  end

  def output
    puts @code
    self
  end
  
  def create
    utils = Utils.new
    utils.generate(@path, "controller", @code)
    self
  end
end
