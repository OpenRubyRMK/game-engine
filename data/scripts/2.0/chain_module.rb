class AnonModule < Module

  attr_reader :name
  def initialize(klass,name,&block)
    super(&block)
    @name = name
    @klass = klass
  end

  def inspect
    return @name ? "<#{self.class}:#@klass:#@name>" : super
  end
end

class Module
  def chain(name=nil,&block)
    prepend(AnonModule.new(self,name,&block))
  end
end