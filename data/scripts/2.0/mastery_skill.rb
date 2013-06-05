require_relative "battler_mastery"
require_relative "battler_skill"
require_relative "levelable_skill"

module Game
  class Mastery
    def skills(k=nil)
      list = (0).upto(level).map {|l|
        l = @levels[l]
        l.nil? ? [] : k ? l.skills(k) : l.skills(k).values
      }.compact.flatten

      return k ? list : list.group_by(&:name)
    end
  end

  class Battler

    chain "MasterySkillInfluence" do
      def _skills(key)
        super + active_mastery.each_value.map{|m| key ? m.skills(key) : m.skills.values }.flatten
      end
    end

  end
end