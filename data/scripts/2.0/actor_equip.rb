require_relative "battler_equip"
require_relative "actor"

module RPG
  class Actor
    attr_accessor :equips
    chain "EquipInfluence" do
      def initialize(*)
        super
        @equips = {}
      end

      def _to_xml(xml)
        super
        xml.equips {
          @equips.each {|k,v|
            xml.item(:slot => k,:item => v);
          }
        }
      end

      def _parse_xml(enemy)
        super
        enemy.xpath("equips/item").each {|node|
          @equips[node[:slot].to_sym] = node[:item].to_sym
        }
      end
    end
  end
end

module Game
  class Actor
    chain "EquipInfluence" do
      def initialize(*)
        super
        rpg.equips.each {|slot,item| equip(slot,RPG::BaseItem[item].newGameObj)}
      end
    end
  end
end