require_relative "battler_feature"
require_relative "battler_mastery"

module RPG
  class Feature
      
    attr_accessor :mastery_level
    attr_accessor :mastery_rate
    
    chain "MasteryInfluence" do
      def initialize(*)
        super
        @skills = []
        @mastery_level = Hash.new(0)
        @mastery_rate = Hash.new(1.0)
      end

      def _to_xml(xml)
        super

        xml.mastery_level{
          @mastery_level.each{|n,v| xml.mastery(v,:name=>n) }
        }
        xml.mastery_rate{
          @mastery_rate.each{|k,v| xml.mastery(v,:name=>k) }
        }

      end

      def parse_xml(feature)
        super

        feature.xpath("mastery_level/mastery").each {|node|
          @mastery_level[node[:name].to_sym] = node.text.to_f
        }
        
        feature.xpath("mastery_rate/mastery").each {|node|
          @mastery_rate[node[:name].to_sym] = node.text.to_f
        }
      end
    end
  end
end

module Game
  class Battler
    chain "FeatureMasteryInfluence" do
      def _mastery_rate(k)
        super + available_features.flat_map {|f| k ? f.mastery_rate[k] : f.mastery_rate }
      end
    end
  end

  class Mastery
    chain "FeatureMasteryInfluence" do
      def _level
        super + @battler.available_features.flat_map {|k,f| f.rpg.mastery_level[@name]}
      end
    end
  end
end
