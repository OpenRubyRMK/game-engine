require "element"
require "proxy"
require "ability"
class RPG::Ability
	attr_reader :damage_elements,:defense_elements
	def damage_elements=(value)
		@damage_elements.replace(value)
		return value
	end
	def defense_elements=(value)
		@defense_elements.replace(value)
		return value
	end
	private
	def ability_cs_init
		#element => { level => boost}
		@damage_elements=Proxy.new({},Element,{})
		@defense_elements=Proxy.new({},Element,{})
	end
end

class Game::Ability
	def damage_elements
		result = {}
		data.damage_elements.each {|el,temp| temp.each{|l,v| result[el]=v if l==@level}}
		return result
	end
	
	def defense_elements
		result = {}
		data.defense_elements.each {|el,temp| temp.each{|l,v| result[el]=v if l==@level}}
		return result
	end
end