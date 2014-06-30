require_relative "ability_feature"
require_relative "levelable_skill"

module Game
  class Ability
    def skills(k=nil)
      return _list_group_by(_featureable_skills(k), k)
    end
    def available_skills(k=nil)
      return _list_group_by(_featureable_skills(k, @battler), k)
    end
  end
end
