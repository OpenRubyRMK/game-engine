require_relative "battler_equip"
require_relative "mastery"

module Game
  class Battler

    attr_accessor :mastery

    chain "MasteryInfluence" do
      def initialize(*)
        super
        @mastery = {}
      end

    end

    def _active_mastery(m)
      return [equips.each_value.map(&:equip_type).include?(m.name)]
    end

    def _mastery_rate(k)
      []
    end

    def mastery_active?(k)
      @mastery.include?(k) && _active_mastery(@mastery[k]).all?
    end

    def active_mastery
      @mastery.select{|k,_| mastery_active?(k)}
    end

    def mastery_rate(k=nil)
      temp = _mastery_rate(k)
      if k
        return temp.inject(1.0,:*)
      else
        return temp.inject(Hash.new(1.0)) do |element,hash|
          hash.merge(element) {|k,o,n| o * n}
        end
      end
    end

    def add_mastery(k)
      return @mastery[k] if @mastery.include?(k)
      return notify_observers(:added_mastery) {
        @mastery[k] = Mastery.new(k,self)
      }
    end

  end
end
