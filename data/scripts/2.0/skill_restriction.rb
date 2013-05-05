require_relative "skill"
require_relative "battler"

module RPG
  class Skill
    attr_accessor :warmup, :cooldown
  end
end

module Game
  class Battler
    def warmup_rate
      return stat(:warmup_rate,1.0)
    end

    def cooldown_rate
      return stat(:cooldown_rate,1.0)
    end

    def warmup(skill)
      [RPG::Skill[skill].warmup * warmup_rate,0].max.to_i
    end

    def warmup(skill)
      [RPG::Skill[skill].warmup * warmup_rate,0].max.to_i
    end

  end
end