class Utils
  def uncapitalize (s)
    s[0, 1].downcase + s[1..-1]
  end
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

  def generate(path, type, code)
    full_file_path = $project_root + "/" + $config["path_to_ext_app"] + path_to_file(path, type)
    puts "Generate #{type} in #{full_file_path}"
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

  def options_equality_parser(options)
    equalited_map = {}
    contains_equality = options.select do |o| o.include? "=" end
    contains_equality.each do |element|
      parsed = element.split("=")
      equalited_map[parsed[0]] = parsed[1]
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
        $config = YAML.load_file("#{search_dir}/extgen_config.yml")
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
end
