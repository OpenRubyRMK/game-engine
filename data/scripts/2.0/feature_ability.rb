require_relative "battler_feature"
require_relative "battler_ability"

module RPG
  class Feature
      
    attr_accessor :ability_level
    chain "AbilityInfluence" do
      def initialize(*)
        super
        @skills = []
        @ability_level = Hash.new(0)
      end

      def _to_xml(xml)
        super

        xml.ability_level{
          @ability_level.each{|n,v| xml.ability(v,:name=>n) }
        }

      end

      def parse_xml(feature)
        super

        feature.xpath("ability_level/ability").each {|node|
          @ability_level[node[:name].to_sym] = node.text.to_f
        }

      end
    end
  end
end

module Game
  class Ability
    chain "FeatureAbilityInfluence" do
      def _level
        super + @battler.available_features.flat_map {|k,f| f.rpg.ability_level[@name]}
      end
    end
  end
end
