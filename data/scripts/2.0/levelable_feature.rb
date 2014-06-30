require_relative "levelable"
require_relative "featureable"

module RPG
  module Levelable
    class Level
      prepend Featureable
    end
  end
end

module Game
  module Levelable
    class Level
      include Featureable
    end
  end
end
