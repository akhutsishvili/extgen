require 'json'

class String
  def numeric?
    return true if self =~ /\A\d+\Z/
    true if Float(self) rescue false
  end

  def to_bool
    return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
    return false  if self == false  || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def eval_value
    r = nil
    if self.numeric?
      r = self.to_i
    elsif self == "true" || self == "false"
      r = self.to_bool
    else
      r = self
    end
    r
  end
end  

class ::Hash
    def deep_merge(second)
        merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
        self.merge(second.to_h, &merger)
    end
end

class Utils
  def uncapitalize (s)
    s[0, 1].downcase + s[1..-1]
  end
  def path_to_alias(path)
    t = path.split(".")
    first, *rest, last = t

    capped = rest.map do |p|
      p.sub(/\S/, &:upcase)
    end
    first + capped.join + last
  end

  def path_to_file(path, type)
    *dirs, fname = path.split(".")
    standartized_dir_names = dirs.map do |d|
      self.uncapitalize(d) + "/"
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

  def create_file(path, type, code)
    full_file_path = $project_root + "/" + $config[:path_to_ext_app] + path_to_file(path, type)
    puts "Generate #{type} in #{full_file_path}"
    create_dirs_for_path(full_file_path, type)
    write_to_file(full_file_path, code)
  end

  def parse_argv
    {
      :tpl => ARGV[0],
      :path => ARGV[1],
      :options => ARGV[2..-1]
    }
  end

  def options_equality_parser(options)
    equalited_map = {}
    contains_equality = options.select do |o| o.include? "=" end
    contains_equality.map do |element|
      key, value = element.split("=")
      key = key.gsub("-", "").to_sym
      equalited_map[key] = value
    end
    equalited_map
  end

  def set_project_root()
    execute_dir = Dir.pwd
    search_dir = execute_dir.split("/")
    begin
      search_dir = search_dir.join("/")
      found_files = Dir.glob("#{search_dir}/extgen_config.yml")
      if found_files.length == 1
        config = YAML.load_file("#{search_dir}/extgen_config.yml")
        $config = config.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        $project_root = search_dir
        break
      else
        search_dir = search_dir.split("/")[0...-1]
      end
    end while search_dir.length > 1

    # Report config not found error
    if $config.nil?
      puts "Error: Can not find extgen_config.yml config file."
      abort
    end
  end

  def generate_attrs(attrs)
    converted = []
    l = attrs.length - 2
    i = 0
    until l < i do
      converted.push(attrs[i].to_s + ",\n")
      i +=1
    end
    converted.push attrs[attrs.length - 1]
    converted.join()
  end

  def export_js_notation(notation)
    path, value = notation.split ":"
    path = path.split(".").map { |m| m.to_sym }
    value = value.tr("'", "").eval_value
    {}.merge!((path + [value]).reverse.reduce { |s,e| { e => s } }) { |k,o,n| o.merge(n) }

  end
  
  def parse_js_notation(notations)
    hash = {}
    notations.each do |n|
      e = export_js_notation n
      hash = hash.deep_merge e
    end
    hash
  end

  def generate_js_object(hash)
    JSON.generate(hash)[1..-2] + ','
  end

  def extract_colin_options
    args = self.argv_parser
    args[:options].select { |o| o.include? ":" }
  end

  def get_tpl_type tpl
    types = YAML.load_file("#{$script_location}/templates/tpl_types.yml")
    types = types.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    types[tpl.to_sym]
  end
  
end
