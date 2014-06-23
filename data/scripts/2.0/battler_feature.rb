require_relative "battler"
require_relative "feature"

module Game
  class Battler
    def _features
      []
    end

    def features
      #if _stack[:features]
      #  _stack[:features] = false
      #  return []
      #end

      #p caller
      #_stack[:features] = true
      return _features
    end
    
    def available_features
      features.select {|f| f.requirement.check(self) }
    end
  end
end