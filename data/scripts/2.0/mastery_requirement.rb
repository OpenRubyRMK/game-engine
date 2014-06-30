require_relative "battler_mastery"

module RPG
  class Mastery
    attr_reader :active_requirement
    chain "RequirementInfluence" do
      def initialize(*)
        super
        @active_requirement = BattlerRequirement.new
      end
      
		  def parse_xml(feature)
		    feature.xpath("active_requirement").each {|r| @active_requirement.parse_xml(r) }
		  end

		  def _to_xml(xml)
		    super
		    xml.active_requirement { @active_requirement.to_xml(xml) }
		  end

    end
    
  end
end

module Game
  class Battler
    chain "MasteryRequirementInfluence" do
      def _active_mastery(m)
        super + [m.rpg.active_requirement.check(self)]
      end
    end
  end
end
