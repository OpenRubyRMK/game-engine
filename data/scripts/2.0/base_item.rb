require_relative "base_object"

module RPG
  class BaseItem < BaseObject

    attr_accessor :price
    #translation :name,:description
    def initialize(name)
      @price=0
      super
    end

    def newGameObj
      return Game.const_get(self.class.name.split("::").last).new(@name)
    end
  end
end

module Game
  class BaseItem < BaseObject

    def price
      return stat(:price,rpg.price)
    end
    
    private

    def _stat_sum(key,type)
      []
    end

    def _stat_multi(key,type)
      []
    end

    def _stat_add(key,type)
      []
    end

    def stat(key,default=0,type=nil)
      temp = _stat_sum(key,type).inject(default,:+)
      temp = _stat_multi(key,type).inject(temp,:*)
      temp = _stat_add(key,type).inject(temp,:+)
      return temp
    end

    def stat_multi(key,default=1.0,type=nil)
      return _stat_multi(key,type).inject(default,:*)
    end
  end
end
