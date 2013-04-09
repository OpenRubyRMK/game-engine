require "battler"
require "proxy"
class Game::Unit
	include Enumerable
	include Game::GameClasses
	attr_proxy :members
	def initialize
		@members=Proxy.new([],Game::Battler)
		cs_init
	end
	def each(&block)
		return @members.each(&block)
	end
end