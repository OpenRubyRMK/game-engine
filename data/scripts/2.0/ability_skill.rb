require_relative "battler_ability"
require_relative "levelable_skill"

module Game
  class Ability
    def skills(k=nil)
      if l = @levels[level]
        return k ? l.skills[k] : l.skills
      end
      return k ? [] : {}
    end
  end
  class Battler
    chain "AbilitySkillInfluence" do
      def _skills(key)
        super + @abilities.each_value.map{|ab| key ? ab.skills(key) : ab.skills.values }.flatten
      end
    end
  end
end