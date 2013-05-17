require_relative "requirement"
require_relative "battler_ability"

module RPG
  class Requirement
    attr_accessor :abilities
    
    chain "AbilityInfluence" do
      def initialize
        super
        @abilities = {:all => {}, :any => {}, :one => {}, :none => {}}
      end
      
      def _check(battler)
        super + [check_array_level(@abilities,battler.abilities)]
      end
      
      def to_xml(xml)
        super
        _to_xml_array(xml,@abilities,"ability","abilities")
      end
    end
  end
end
