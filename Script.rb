class Script
  @generator = nil

  def initialize g
    @generator = g
  end
  
  def create_store
    path =  @generator.instance_variable_get(:@path)
    o = @generator.instance_variable_get(:@options)
    Generator.new('store', path, o).generate().create().get_full_path
    # create model
    # if @generator.option? "-m"
    #   self.create_model
    # end
  end

  def create_model

  end
end
