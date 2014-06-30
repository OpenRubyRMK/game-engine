require_relative "actorclass_feature"
require_relative "levelable_skill"

module Game
  class ActorClass
    def skills(k=nil)
      return _list_group_by(_featureable_skills(k), k)
    end
    def available_skills(k=nil)
      return _list_group_by(_featureable_skills(k, @battler), k)
    end
  end
end
