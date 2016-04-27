require 'yaml'
$config = YAML.load_file('extgen_config.yml')

class Utils
  def path_to_alias(path)
    t = path.split(".")
    first, *rest, last = t

    capped = rest.map do |p|
      p.capitalize
    end
    first + capped.join + last
  end

  def path_to_file(path, type)
    *dirs, fname = path.split(".")
    standartized_dir_names = dirs.map do |d|
      d.downcase + "/"
    end
    type + "/" +  standartized_dir_names.join + fname + ".js"
  end

  def create_dirs_for_path(path, type)
    require 'fileutils'
    *dirs, file_name = path.split("/")
    concated_dirs = dirs.join('/')
    FileUtils::mkdir_p concated_dirs unless File.exists?(concated_dirs)
  end

  def write_to_file(file, code)
    out_file = File.new(file, "w")
    out_file.puts(code)
    out_file.close
  end

  def generate(path, type, code)
    full_file_path = path_to_file(path, type)
    create_dirs_for_path(full_file_path, type)
    write_to_file(full_file_path, code)
  end

  def argv_parser
    {
      :type => ARGV[0],
      :path => ARGV[1],
      :options => ARGV[2..-1]
    }
  end

end

class Model
  def create(path, params)
    utils = Utils.new
    code = [
      "Ext.define('#{$config["project_name"]}.store.#{path}', {",
      "    extend: 'Ext.data.Model',",
      "    fields: [{",
      "        name: 'id',",
      "        type: 'int'",
      "    }]",
      "})"
    ]
    utils.generate(path, "model", code)
  end
end

class Store

  def create(path, params)
    utils = Utils.new
    store_path = "#{$config["project_name"]}.store.#{path}"
    code = [
      "Ext.define('#{store_path}') {",
      "    extend: 'Ext.data.Store',",
      "    model:  Ext.create('Ext.data.Model'),",
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
    if params.include? "-m"
      Model.new().create(path, params)
    end
    store_path
  end
end

class ComboBox
  @@path = ""
  @@params = ""
  @@constructor_code = [
    "    constructor: function (cfg) {",
    "       cfg = cfg || {}",
    "       var me = this",
    "    }"
  ]
  def initialize(path, params)
    @@path = path
    @@params = params
    utils = Utils.new
    element_alias = utils.path_to_alias path
    @code = [
      "Ext.define('#{$config["project_name"]}.view.#{path}'') {",
      "    fieldLabel: '',",
      "    extend: 'Ext.form.ComboBox',",
      "    alias: 'widget.#{element_alias}'",
      "    name: ''"
    ]

    if @@params.include? "-s"
      store_path = Store.new().create(@@path, @@params)
      @code.push("    store: {xclass: '#{store_path}'},")
    end

    if @@params.include? "-c"
      @code.push @@constructor_code
    end
    @code.push "})"
    self
  end

  def create()
    Utils.new().generate(@@path, "view", @code)
    self
  end
end

utils = Utils.new()
params = utils.argv_parser
if params[:type] == "combo"
  ComboBox.new(params[:path], params[:options]).create()
end
