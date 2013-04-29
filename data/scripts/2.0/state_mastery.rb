require_relative "battler_state"
require_relative "battler_mastery"

module RPG
  class State
    attr_accessor :level_masteries

    chain "StateMasteryInfluence" do
      def initialize(*)
        super
        @level_masteries = Hash.new(0)
      end

      def _to_xml(xml)
        super
        xml.level_masteries {
          @level_masteries.each{|k,l| xml.mastery(:name=>k,:value=>l) }
        }
      end

      def _parse_xml(item)
        super
        item.xpath("level_masteries/mastery").each {|node|
          @level_masteries[node[:name].to_sym]=node[:value].to_i
          Mastery.parse_xml(node) unless node.children.empty?
        }
      end
    end
  end
end

module Game
  class Mastery
    chain "StateMasteryInfluence" do
      def _level
        super + @battler._states(nil).map {|st| st.rpg.level_masteries[@name]}
      end
    end
  end
end