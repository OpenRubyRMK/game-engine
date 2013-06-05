require_relative "chain_module"
module RPG
  class Feature
    def _to_xml(xml)
    end
    def _parse_xml(feature)
    end

    def to_xml(xml)
      xml.feature { _to_xml(xml) }
    end

    def self.parse_xml(xml)
      feature = new
      feature._parse_xml(xml)
      return feature
    end
  end
end

module Game
  class Feature
    def initialize(rpg)
    end
  end
end