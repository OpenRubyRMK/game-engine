require_relative "levelable"
require_relative "state"

module RPG
  module Levelable
    class Level
      attr_accessor :state_rate
      chain "StateInfluence" do
        def initialize(*)
          super
          @state_rate = Hash.new(1.0)
        end
        
        def _to_xml(xml)
          super
          xml.state_rate{
            @state_rate.each{|k,v| xml.state(v,:name=>k) }
          }
        end
  
        def _parse_xml(level)
          super
          level.xpath("state_rate/state").each {|node|
            @state_rate[node[:name].to_sym] = node.text.to_f
          }
        end
      end
    end
  end
end