require "test/unit"

require_relative "../enemy_state"
require_relative "../actor_state"

require_relative "../equippable_item_states"

require_relative "../enemy_equip"
require_relative "../actor_equip"

require_relative "../state_feature"


require_relative "../weapon"

class StateTest < Test::Unit::TestCase
  def self.startup
    s=RPG::State.new(:burn)
    s.states_chance[:freeze] = 0.5

    s=RPG::State.new(:freeze)

    s=RPG::State.new(:burnprotection)
    s.features << RPG::Feature.new.tap {|f| f.suspend_states << :burn }
    
    #st=RPG::Weapon.new(:staff)
    #st.states_chance[:freeze] = 0.5
    #warrior=RPG::ActorClass.new(:warrior)
    #warrior.states_chance[:freeze] = 0.5

    e = RPG::Enemy.new(:slime)
    e.features << RPG::Feature.new.tap{|f| f.auto_states << :burn}
    #e.states_chance[:freeze] = 0.5

    e = RPG::Enemy.new(:wizzard)
    e.features << RPG::Feature.new.tap{|f| f.states_chance[:freeze] = 0.5 }

    e = RPG::Enemy.new(:human)

    e = RPG::Enemy.new(:ogre)
    e.equips[:hand] = :axe

    e = RPG::Enemy.new(:whyzard)
    e.equips[:hand] = :staff

    e = RPG::Enemy.new(:guard)
    e.equips[:hand] = :sword

    
    a = RPG::Actor.new(:alex)
    a.features << RPG::Feature.new.tap{|f| f.auto_states << :burn }
    #e.states_chance[:freeze] = 0.5

    a = RPG::Actor.new(:mira)
    a.features << RPG::Feature.new.tap{|f| f.states_chance[:freeze] = 0.5 }

    a = RPG::Actor.new(:ralph)

    a = RPG::Actor.new(:jeff)
    a.equips[:hand] = :sword
    
    a = RPG::Actor.new(:natan)
    a.equips[:hand] = :staff
        
    a = RPG::Actor.new(:brian)
    a.equips[:sword] = :axe
    
    sw = RPG::Weapon.new(:sword)
    sw.equip_features << RPG::Feature.new.tap{|f| f.states_chance[:freeze] = 0.5 }

    st = RPG::Weapon.new(:staff)
    st.equip_features << RPG::Feature.new.tap{|f| f.auto_states << :freeze}
    ax = RPG::Weapon.new(:axe)
    ax.equip_features << RPG::Feature.new.tap{|f| f.auto_states << :burn}
      
    gl = RPG::Weapon.new(:fireglove)
    gl.equip_features << RPG::Feature.new.tap {|f| f.suspend_states << :burn }
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
  
  def test_enemy_equip_auto_states

    go = Game::Enemy.new(:ogre)
    
    assert_not_empty(go.equips)
    assert_not_empty(go.states)
    assert_not_empty(go.states(:burn))
    assert_empty(go.states(:freeze))

    gw = Game::Enemy.new(:whyzard)

    assert_not_empty(gw.equips)
    assert_not_empty(gw.states)
    assert_empty(gw.states(:burn))
    assert_not_empty(gw.states(:freeze))

    gg = Game::Enemy.new(:guard)

    assert_not_empty(gg.equips)
    assert_empty(gg.states)
    assert_empty(gg.states(:burn))
    assert_empty(gg.states(:freeze))
        
  end


  def test_actor_equip_auto_states

    gj = Game::Actor.new(:jeff)
    
    assert_not_empty(gj.equips)
    assert_empty(gj.states)
    assert_empty(gj.states(:burn))
    assert_empty(gj.states(:freeze))

    gn = Game::Actor.new(:natan)
    
    assert_not_empty(gn.equips)
    assert_not_empty(gn.states)
    assert_empty(gn.states(:burn))
    assert_not_empty(gn.states(:freeze))

    gb = Game::Actor.new(:brian)
    
    assert_not_empty(gb.equips)
    assert_not_empty(gb.states)
    assert_not_empty(gb.states(:burn))
    assert_empty(gb.states(:freeze))
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

  def test_equip_auto_states
    sword = Game::Weapon.new(:sword)

    assert_empty(sword.auto_states)

    staff = Game::Weapon.new(:staff)

    assert_not_empty(staff.auto_states)

    gs=Game::Actor.new(:alex)

    assert_empty(gs.equips)
    assert_not_empty(gs.states)
    assert_not_empty(gs.states(:burn))
    assert_empty(gs.states(:freeze))

    gs.equip(:hand,staff)

    assert_not_empty(gs.equips)
    assert_not_empty(gs.states)
    assert_not_empty(gs.states(:burn))
    assert_not_empty(gs.states(:freeze))

    gs.equip(:hand,sword)

    assert_not_empty(gs.equips)
    assert_not_empty(gs.states)
    assert_not_empty(gs.states(:burn))
    assert_empty(gs.states(:freeze))

    gs.equip(:hand,nil)
    
    assert_empty(gs.equips)
    assert_not_empty(gs.states)
    assert_not_empty(gs.states(:burn))
    assert_empty(gs.states(:freeze))

    
    gh=Game::Actor.new(:ralph)
    
    assert_empty(gh.equips)    
    assert_empty(gh.states)
    assert_empty(gh.states(:burn))
    assert_empty(gh.states(:freeze))

    #assert_not_empty(staff.states(:burn))
    #assert_empty(gh.states(:freeze))

    gh.equip(:hand,staff)

    assert_not_empty(gh.equips)
    assert_not_empty(gh.states)
    assert_empty(gh.states(:burn))
    assert_not_empty(gh.states(:freeze))

    gh.equip(:hand,sword)
    
    assert_not_empty(gh.equips)    
    assert_empty(gh.states)
    assert_empty(gh.states(:burn))
    assert_empty(gh.states(:freeze))

    gh.equip(:hand,nil)
    
    assert_empty(gh.equips)    
    assert_empty(gh.states)
    assert_empty(gh.states(:burn))
    assert_empty(gh.states(:freeze))

  end

  def test_equip_states_chance
    sword = Game::Weapon.new(:sword)

    assert_not_empty(sword.states_chance)

    staff = Game::Weapon.new(:staff)

    assert_empty(staff.states_chance)

    gs=Game::Actor.new(:alex)

    assert_equal({:freeze => 0.5},gs.states_chance)
    assert_equal(0.5,gs.states_chance(:freeze))
    assert_equal(1.0,gs.states_chance(:fire))

    gs.equip(:hand,staff)

    assert_equal({:freeze => 0.5},gs.states_chance)
    assert_equal(0.5,gs.states_chance(:freeze))
    assert_equal(1.0,gs.states_chance(:fire))

    gs.equip(:hand,sword)

    assert_equal({:freeze => 0.25},gs.states_chance)
    assert_equal(0.25,gs.states_chance(:freeze))
    assert_equal(1.0,gs.states_chance(:fire))

    gh=Game::Actor.new(:ralph)

    assert_equal({},gh.states_chance)
    assert_equal(1.0,gh.states_chance(:freeze))
    assert_equal(1.0,gh.states_chance(:fire))

    #assert_not_empty(staff.states(:burn))
    #assert_empty(gh.states(:freeze))

    gh.equip(:hand,staff)

    assert_equal({},gh.states_chance)
    assert_equal(1.0,gh.states_chance(:freeze))
    assert_equal(1.0,gh.states_chance(:fire))

    gh.equip(:hand,sword)

    assert_equal({:freeze => 0.5},gh.states_chance)
    assert_equal(0.5,gh.states_chance(:freeze))
    assert_equal(1.0,gh.states_chance(:fire))
  end

  def test_equip_state_suspend
    axe = Game::Weapon.new(:axe)
    glove = Game::Weapon.new(:fireglove)
    
    ga=Game::Actor.new(:alex)
    
    assert_empty(ga.suspended_states)
    assert_not_empty(ga.states)
    assert_not_empty(ga.states(:burn))
      
    ga.equip(:gloves,glove)
    
    assert_not_empty(ga.suspended_states)
    assert_empty(ga.states)
    assert_empty(ga.states(:burn))
      
    ga.equip(:hand,axe)
    
    assert_not_empty(ga.suspended_states)
    assert_empty(ga.states)
    assert_empty(ga.states(:burn))
    
    
  end
  
  def test_state_state_suspend
    ga=Game::Actor.new(:alex)

    assert_empty(ga.suspended_states)
    assert_not_empty(ga.states)
    assert_not_empty(ga.states(:burn))
      
    ga.add_state(:burnprotection)
    
    assert_not_empty(ga.suspended_states)
    assert_empty(ga.states)
    assert_empty(ga.states(:burn))
    
  end

end