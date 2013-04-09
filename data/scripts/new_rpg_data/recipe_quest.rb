require_relative "recipe"
require_relative "quest"

module RPG
	class Recipe
		attr_accessor :requied_quests
		private
		def quests_cs_init
			@requied_quests = []
		end
	end
	class Quest
		attr_accessor :finish_recipe_learned
		attr_accessor :finish_make_recipe
		
		attr_accessor :failed_recipe_learned
		attr_accessor :failed_make_recipe
		private
		def recipe_cs_init
			@finish_recipe_learned = {}
			@finish_make_recipe = {}
	
			@failed_recipe_learned = {}
			@failed_make_recipe = {}
		end
		def recipe_cs_to_xml_finish(xml)
			xml.recipe_learned { @finish_recipe_learned.each{|k,v| xml.quest(:actor=>k,:name=>v)} }
			xml.make_recipe { @finish_make_recipe.each{|k,v| xml.quest(:actor=>k,:name=>v)} }
		end
		def recipe_cs_to_xml_failed(xml)
			xml.recipe_learned { @failed_recipe_learned.each{|k,v| xml.quest(:actor=>k,:name=>v)} }
			xml.make_recipe { @failed_make_recipe.each{|k,v| xml.quest(:actor=>k,:name=>v)} }
		end
	end
end
module Game
	class Actor
		private
		def quest_cs_recipe_can_make(recipe,*)
			return recipe.requied_quests.all?{|q| Quest[q].finished}
		end
		def quest_cs_recipe_learned(recipe)
			Quest.each do |q|
				return unless q.started
				if q.rpg.failed_recipe_learned[@name] == recipe
					q.failed = true
				elsif q.rpg.finish_recipe_learned[@name] == recipe
					q.finish = true
				end
			end
		end
		def quest_cs_make_recipe(recipe,*)
			Quest.each do |q|
				return unless q.started
				if q.rpg.failed_make_recipe[@name] == recipe
					q.failed = true
				elsif q.rpg.finish_make_recipe[@name] == recipe
					q.finish = true
				end
			end
		end
	end
end