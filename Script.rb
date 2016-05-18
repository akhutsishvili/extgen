class Script
  @generator = nil

  def initialize g
    @generator = g
    @path = @generator.instance_variable_get(:@path)
    @options = @generator.instance_variable_get(:@options)
  end
  
  def create_store
    
    Generator.new('store', @path, @options).generate().create().get_full_path
    # create model
    # if @options.option? "-m"
    #   self.create_model
    # end
  end

  def create_model

  end
end
