require_relative "battler_equip"
require_relative "battler_skill"

module RPG
  module EquippableItem
    attr_reader :charge_skills

    chain "ChargeSkillInfluence" do
      def _init_equippable
        super
        @charge_skills = {}
      end

      def _parse_xml_equippable(item)
        super
      end

      def _to_xml_equippable(xml)
        super
        xml.charge_skills{
          @charge_skills.each{|n,c| xml.skill(:name=>n,:charges=>c)}
        }
      end

    end

  end

  class Skill
    attr_accessor :charge_empty_price

    chain "ChargeSkillInfluence" do
      def initialize(*)
        super
        @charge_empty_price = 0
      end
    end

  end
end

module Game
  module ChargeSkill
    attr_accessor :charges # oder soll ich da gleich die uses nutzen?
  end

  module EquippableItem
    attr_reader :charge_skills

    chain "ChargeSkillInfluence" do
      def _init_equippable
        super
        @charge_skills = {}
        rpg.charge_skills.each { |skill,n|
          @charge_skills[skill]=Skill.new(skill).tap{|skill|skill.extend(ChargeSkill).charges = n }
        }
      end

      def _stat_add(key,type)
        super + ( key == :price ? @charge_skills.each_value.map {|skill|
          skill.price * skill.charges + skill.rpg.charge_empty_price
        }  : [])
      end

    end
  end

  class Battler
    chain "ChargeSkillInfluence" do
      def _skills(key)
        super + equips.each_value.flat_map {|e| key ? e.charge_skills[key] : e.charge_skills.values }
      end
    end
  end

end
