require_relative "battler_mastery"

module RPG
  class BattlerRequirement
    attr_accessor :masteries
    
    chain "MasteryInfluence" do
      def initialize
        super
        @masteries = init_check(true)
      end
      
      def _check(battler)
        super + [check_array_level(@masteries,battler.mastery)]
      end
      
      def _empty
      	super + [check_empty(@masteries)]
      end
      
      def to_xml(xml)
        super
        _to_xml_array(xml,@masteries,"mastery","masteries")
      end
      
      def parse_xml(xml)
        super
        _parse_xml(xml,@masteries,"mastery","masteries",true)
      end
    end
  end
end

