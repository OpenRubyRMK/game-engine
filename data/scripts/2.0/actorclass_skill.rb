require_relative "actorclass"
require_relative "battler_skill"
require_relative "levelable_skill"

module Game
  class ActorClass
    def skills(k=nil)
      list = (0).upto(level).map {|l|
        l = @levels[l]
        l.nil? ? [] : k ? l.skills[k] : l.skills.values
        }.compact.flatten

      return k ? list : list.group_by(&:name)
    end
  end
  class Actor
    chain "ActorClassSkillInfluence" do
      def _skills(key)
        super + @actorclasses.each_value.map{|ac| key ? ac.skills(key) : ac.skills.values }.flatten
      end
    end
  end
end