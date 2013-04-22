require "test/unit"

require_relative "../enemy_skill"
require_relative "../enemy_state"

require_relative "../battler_ability"

class EventTest < Test::Unit::TestCase
  def self.startup
    RPG::Skill.new(:fireball)
		RPG::State.new(:burn)
    RPG::Enemy.new(:slime)
    RPG::Ability.new(:fireart)
  end
  
  def test_battler_events
  	Game.observe(:added_skill) {|_,_,_| throw :added_skill}
		Game.observe(:removed_skill) {|_,_,_| throw :removed_skill}

		Game.observe(:added_state) {|_,_,_| throw :added_state}
		Game.observe(:removed_state) {|_,_,_| throw :removed_state}

		Game.observe(:added_ability) {|_,_,_| throw :added_ability}
			
  	enemy = Game::Enemy.new(:slime)
  	
  	assert_throws(:added_skill){enemy.add_skill(:fireball)}
  	assert_throws(:removed_skill){enemy.remove_skill(:fireball)}

  	assert_throws(:added_state){enemy.add_state(:burn)}
  	assert_throws(:removed_state){enemy.remove_state(:burn)}
  	
  	assert_throws(:added_ability){enemy.add_ability(:fireart)}
  end
end
