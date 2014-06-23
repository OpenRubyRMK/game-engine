require_relative "chain_module"
require_relative "requirement"
module RPG
  class Feature
    attr_reader :requirement
    def initialize
      @requirement = Requirement.new
    end
    
    def _to_xml(xml)
    end
    def parse_xml(feature)
      feature.xpath("requirement").each {|r| @requirement.parse_xml(r) }
    end

    def to_xml(xml)
      xml.feature {
        xml.requirement { @requirement.to_xml(xml) }
        _to_xml(xml)
      }
    end

    def self.parse_xml(xml)
      feature = new
      feature.parse_xml(xml)
      return feature
    end
  end
end

module Game
  class Feature
    attr_reader :requirement
    def initialize(rpg)
      @requirement = rpg.requirement
    end
  end
end
