require_relative "actor"
require_relative "battler_feature"

module RPG
  class Actor
    include Featureable
  end
end

module Game
  class Actor
    prepend Featureable
  end
end
