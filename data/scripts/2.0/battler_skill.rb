require_relative "battler"
require_relative "skill"

require_relative "chain_module"

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
      key ? _skills(key) : _skills(key).group_by(&:name)
    end
    
    def add_skill(k)
			return notify_observers(:added_skill) {
  			@skills[k] += [temp = Skill.new(k)]
  			temp
  		}
    end
    
    def remove_skill(k)
      unless(@skills[k].empty?)
      	return notify_observers(:removed_skill) { @skills[k].shift }
      else
        return nil
      end
    end
    
  end
end
