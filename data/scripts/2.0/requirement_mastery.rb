require_relative "requirement"
require_relative "battler_mastery"

module RPG
  class Requirement
    attr_accessor :masteries
    
    chain "MasteryInfluence" do
      def initialize
        super
        @masteries = init_check(true)
      end
      
      def _check(battler)
        super + [check_array_level(@masteries,battler.mastery)]
      end
      
      def to_xml(xml)
        super
        _to_xml_array(xml,@masteries,"mastery","masteries")
      end
    end
  end
end

