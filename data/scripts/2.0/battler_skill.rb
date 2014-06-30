require_relative "battler"
require_relative "skill"

module Game
  class Battler

    chain "SkillInfluence" do
      def initialize(*)
        super
        @skills ||= Hash.new([])
      end

    end

    def _skills(key = nil)
      return key ? @skills[key] : @skills.values.flatten
    end

    def skills(key=nil)
      return _list_group_by(_skills(key), key)
    end
    
    def _available_skills(key = nil)
      return []
    end
    
    def available_skills(key=nil)
      return _list_group_by(_available_skills(key), key)
    end

    def add_skill(k)
      return notify_observers(:added_skill) {
        @skills[k] += [temp = Skill.new(k)]
        temp
      }
    end

    def remove_skill(k)
      unless @skills[k].empty?
        return notify_observers(:removed_skill) { @skills[k].shift }
      else
        return nil
      end
    end

  end
end
