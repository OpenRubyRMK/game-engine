require_relative "requirement"
require_relative "battler_state"

module RPG
  class Requirement
    attr_accessor :states
    
    chain "AbilityInfluence" do
      def initialize
        super
        @states = init_check
      end
      
      def _check(battler)
        super + [check_array(@states,battler.states)]
      end
      
      def to_xml(xml)
        super
        _to_xml_array(xml,@states,"state","states")
      end
      
      
      def parse_xml(xml)
        super
        _parse_xml(xml,@states,"state","states")
      end
    end
  end
end