class Script
  @generator = nil

  def initialize g
    @generator = g
    @path = @generator.instance_variable_get(:@path)
    @options = @generator.instance_variable_get(:@options)
  end
  
  def create_store
    Generator.new('store', @path, @options).generate().create().get_full_path
  end

  def remove_store
    Generator.new('store', @path, @options).generate().remove().get_full_path
  end

  def create_model
    Generator.new('model', @path, @options).generate().create().get_full_path
  end

  def remove_model
    Generator.new('model', @path, @options).generate().remove().get_full_path
  end
end
