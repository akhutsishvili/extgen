require "erb"
require_relative "#{$script_location}/Utils"

class Generator
  @tpl = nil
  @tpl_type = nil
  @full_path = nil
  @path = nil
  @options = nil
  @code = nil
  @tpl_file = nil
  @params = nil
  @element_alias = nil
  @store = nil
  @model = nil
  @eq_options = nil

  def initialize(tpl, path, options)
    u = Utils.new
    @params = u.parse_argv
    @tpl = tpl.capitalize
    @path = path
    @options = options
    @element_alias = u.path_to_alias @path
    @eq_options = u.options_equality_parser options
    @tpl_type = u.get_tpl_type @tpl
    @full_path = [$config[:project_name], @tpl_type, @path].join "."
  end

  def set_tpl_file
    @tpl_file = "#{$script_location}/templates/#{@tpl}.erb"
  end
  
  def generate_code_from_template
    template = File.read @tpl_file
    renderer = ERB.new(template)

    @code = renderer.result(binding)
  end

  def option? option
    @options.include? option
  end

  def get_full_path
    @full_path
  end
  
  def generate
    self.set_tpl_file
    self.generate_code_from_template
    self
  end

  def create
    Utils.new().create_file(@path, @tpl_type, @code)
    self
  end
  
end
