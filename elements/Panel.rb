require_relative "../Utils"
require_relative "Element"

class Panel < Element

  def initialize(path, options)
    super
    @path = path
    @options = options
    utils = Utils.new
    element_alias = utils.path_to_alias path
    @code = [
      "Ext.define('#{$config["project_name"]}.view.#{path}', {",
      "    title: '',",
      "    extend: 'Ext.panel.Panel',",
      "    alias: 'widget.#{element_alias}',",
    ]

    self.create_layout()
    self.create_constructor()

    @code.push "})"

    self
  end


end
