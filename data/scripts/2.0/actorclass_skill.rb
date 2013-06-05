require_relative "actorclass_feature"
require_relative "levelable_skill"

module Game
  class ActorClass
    def skills(k=nil)
      list = features.map {|f| f.skills(k)}.flatten

      return k ? list : list.group_by(&:name)
    end
  end

  #currently removed, is done via features
  
  #class Actor
  #  chain "ActorClassSkillInfluence" do
  #    def _skills(key)
  #      super + @actorclasses.each_value.map{|ac| key ? ac.skills(key) : ac.skills.values }.flatten
  #    end
  #  end
  #end
end