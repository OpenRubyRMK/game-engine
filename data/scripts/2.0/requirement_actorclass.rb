require_relative "actorclass"

module RPG
  class BattlerRequirement
    attr_accessor :actorclasses
    
    chain "AbilityInfluence" do
      def initialize
        super
        @actorclasses = init_check(true)
      end
      	
      def _check(battler)
        super + [battler.is_a?(Actor) ? check_array_level(@actorclasses,battler.actorclasses) : check_empty(@actorclasses)]
      end
      
      def _empty
      	super + [check_empty(@actorclasses)]
      end
      
      def to_xml(xml)
        super
        _to_xml_array(xml,@actorclasses,"actorclass","actorclasses")
      end
      
      def parse_xml(xml)
        super
        _parse_xml(xml,@actorclasses,"actorclass","actorclasses",true)
      end
    end
  end
end
