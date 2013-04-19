require "test/unit"

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

class TestChaining < Test::Unit::TestCase

  def test_chaining_initilisation
    klass = Class.new do
      chain "foo" do
        def foo
          "foo"
        end
      end
    end
    assert_equal "foo", klass.ancestors.first.name
  end

  def test_chaining_implementation
    klass = Class.new do
      chain do
        def foo
          "class foo"
        end
      end
    end

    assert_equal "class foo", klass.new.foo

    klass.chain do
      def foo
        super.to_s + "more foo"
      end
    end

    assert_equal "class foomore foo", klass.new.foo

  end

end
