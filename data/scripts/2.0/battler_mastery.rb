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

    def active_mastery
    	types = equips.each_value.map(&:equip_type)
    	
    	@mastery.select{|k,_| types.include?(k)} 
    end
    
    def add_mastery(k)
    	return @mastery[k] if @mastery.include?(k)
			return notify_observers(:added_mastery) {
				@mastery[k] = Mastery.new(k,self)
  		}
    end
    
  end
end
