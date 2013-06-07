require "test/unit"

require_relative "../troop"
require_relative "../enemy_swap"

class TroopTest < Test::Unit::TestCase
  def self.startup
    RPG::State.new(:dead)
    
    s=RPG::Enemy.new(:slime)
    s.swap_enemies[:red_slime] = 5
    s.swap_enemies[:green_slime] = 5
    s.swap_enemies[:blue_slime] = 15
    
    [:red_slime, :green_slime, :blue_slime].each {|key|
      RPG::Enemy.new(key).tap {|e|
        e.stats[:hp] = 10
          e.dead_state = :dead
      }
    }
    
    t=RPG::Troop.new(:sime_group)
    t.members << :slime << :slime << :slime
  end
  
  def test_swap_enemy
    
    g=Game::Troop.new(:sime_group)

    assert_equal(3,g.each.size)
    assert_equal(3,g.alive_members.size)
    assert_equal(0,g.dead_members.size)
    
    assert_not_equal(g.map(&:name),:slime) #because each slime is replaced
    
    3.times {|i|
      assert_equal(10,g.to_a[i].hp)      
      assert_true(g.to_a[i].alive?)
    }
    
    enemy = g.each.first
    enemy.hp -= 10
    
    assert_equal(0,enemy.hp)
    assert_true(enemy.dead?)
    
    assert_equal(3,g.each.size)
    assert_equal(2,g.alive_members.size)
    assert_equal(1,g.dead_members.size)
    
  end
end