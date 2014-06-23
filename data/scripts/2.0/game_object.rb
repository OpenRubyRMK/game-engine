require "observer"

module Game
  extend Observable
  def self.observe(target_event = nil)
    callback = lambda do |event, emitter, info|
      yield(event, emitter, info) if !target_event || event == target_event
    end

    add_observer(callback, :call)
  end

  class BaseObject
    attr_reader :name
    def initialize(name,*)
      @name = name
    end

    def to_sym
      return @name
    end

    def rpg
      raise NotImplementedError
    end

    def notify_observers(event, info = {})
      if block_given?
        Game.changed
        info = yield
      end
      Game.notify_observers(event, self, info)
      info
    end

  end
end
