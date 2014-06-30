require_relative "requirement"
require_relative "battler_ability"

module RPG
  class BattlerRequirement
    attr_accessor :abilities
    
    chain "AbilityInfluence" do
      def initialize
        super
        @abilities = init_check(true)
      end
      	
      def _check(battler)
        super + [check_array_level(@abilities,battler.abilities)]
      end
      
      def _empty
      	super + [check_empty(@abilities)]
      end
      
      def to_xml(xml)
        super
        _to_xml_array(xml,@abilities,"ability","abilities")
      end
      
      def parse_xml(xml)
        super
        _parse_xml(xml,@abilities,"ability","abilities",true)
      end
    end
  end
end
