require "test/unit"
require "turn/autorun"

require_relative "../enemy_state"
require_relative "../actor_state"

class StateTest < Test::Unit::TestCase
 
  def setup
    s=RPG::State.new(:burn)
    s.states_chance[:freeze] = 0.5
   
    s=RPG::State.new(:freeze)
    
    #st=RPG::Weapon.new(:staff)
    #st.states_chance[:freeze] = 0.5
    #warrior=RPG::ActorClass.new(:warrior)
    #warrior.states_chance[:freeze] = 0.5
    
    e = RPG::Enemy.new(:slime)
    e.auto_states << :burn
    #e.states_chance[:freeze] = 0.5
    
    e = RPG::Enemy.new(:wizzard)
    e.states_chance[:freeze] = 0.5
    
    e = RPG::Enemy.new(:human)
    
    a = RPG::Actor.new(:alex)
    a.auto_states << :burn
    #e.states_chance[:freeze] = 0.5
    
    a = RPG::Actor.new(:mira)
    a.states_chance[:freeze] = 0.5
    
    a = RPG::Actor.new(:ralph)
  
  end
  
  def test_enemy_state_chance
    gs=Game::Enemy.new(:slime)
    
    assert_equal({:freeze => 0.5},gs.states_chance)
    assert_equal(0.5,gs.states_chance(:freeze))
    assert_equal(1.0,gs.states_chance(:fire))
    
    gw=Game::Enemy.new(:wizzard)
    
    assert_equal({:freeze => 0.5},gw.states_chance)
    assert_equal(0.5,gw.states_chance(:freeze))
    assert_equal(1.0,gw.states_chance(:fire))
      
    gh = Game::Enemy.new(:human)

    assert_equal({},gh.states_chance)
    assert_equal(1.0,gh.states_chance(:freeze))
    assert_equal(1.0,gh.states_chance(:fire))

    gh.add_state(:burn)

    assert_equal({:freeze => 0.5},gh.states_chance)
    assert_equal(0.5,gh.states_chance(:freeze))
    assert_equal(1.0,gh.states_chance(:fire))

    
  end

  def test_actor_state_chance
    gs=Game::Actor.new(:alex)
    
    assert_equal({:freeze => 0.5},gs.states_chance)
    assert_equal(0.5,gs.states_chance(:freeze))
    assert_equal(1.0,gs.states_chance(:fire))
    
    gw=Game::Actor.new(:mira)
    
    assert_equal({:freeze => 0.5},gw.states_chance)
    assert_equal(0.5,gw.states_chance(:freeze))
    assert_equal(1.0,gw.states_chance(:fire))
      
    gh = Game::Actor.new(:ralph)

    assert_equal({},gh.states_chance)
    assert_equal(1.0,gh.states_chance(:freeze))
    assert_equal(1.0,gh.states_chance(:fire))

    gh.add_state(:burn)

    assert_equal({:freeze => 0.5},gh.states_chance)
    assert_equal(0.5,gh.states_chance(:freeze))
    assert_equal(1.0,gh.states_chance(:fire))

    
  end

    
  def test_enemy_auto_states
    gs=Game::Enemy.new(:slime)
     
    assert_not_empty(gs.states)
    assert_not_empty(gs.states(:burn))
    assert_empty(gs.states(:freeze))
    
    gw=Game::Enemy.new(:wizzard)
    
    assert_empty(gw.states)
    assert_empty(gw.states(:burn))
    assert_empty(gw.states(:freeze))
  
    gh=Game::Enemy.new(:human)
      
    assert_empty(gh.states)
    assert_empty(gh.states(:burn))
    assert_empty(gh.states(:freeze))

    gh.add_state(:burn)

    assert_not_empty(gh.states)
    assert_not_empty(gh.states(:burn))
    assert_empty(gh.states(:freeze))
        
  end
  
	def test_actor_auto_states
	    gs=Game::Actor.new(:alex)
	     
	    assert_not_empty(gs.states)
	    assert_not_empty(gs.states(:burn))
	    assert_empty(gs.states(:freeze))
	    
	    gw=Game::Actor.new(:mira)
	    
	    assert_empty(gw.states)
	    assert_empty(gw.states(:burn))
	    assert_empty(gw.states(:freeze))
	  
	    gh=Game::Actor.new(:ralph)
	      
	    assert_empty(gh.states)
	    assert_empty(gh.states(:burn))
	    assert_empty(gh.states(:freeze))
	
	    gh.add_state(:burn)
	
	    assert_not_empty(gh.states)
	    assert_not_empty(gh.states(:burn))
	    assert_empty(gh.states(:freeze))
	        
	  end
  
end