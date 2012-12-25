require 'rubygems'
require 'gosu'
require 'tiled_tmx'
require 'yaml'
require "pathname"
require 'singleton'

module TiledTmx
	class Tileset
		def draw(i,x,y,z,opacity,rot,x_scale,y_scale)
			unless(@tiled)
				@tiled = Gosu::Image.load_tiles(
				GameWindow.instance,
				source.to_s,
				tilewidth+spacing, tileheight+spacing, true)
			end
			@tiled[i].draw_rot(x+(tilewidth*x_scale.abs/2),y+(tileheight*y_scale.abs/2),
				z,rot,0.5,0.5,x_scale,y_scale,
				Gosu::Color.new( 255, 255, 255,(255 * opacity).round)
			)
		end
	end
end

class GameWindow < Gosu::Window
	include Singleton

  def initialize
    super(640, 480, false)

		rootdir = Pathname.new(__FILE__).dirname.parent
		bindir = rootdir + "bin"
		datadir = rootdir + "data"
		mapdir = datadir + "maps"
		projectfile = YAML.load_file(bindir + "foo.rmk")
		self.caption = projectfile["project"]["name"]

		@map = TiledTmx::Map.load_xml(mapdir + "0002.tmx")
	end
	
	def draw
		@map.draw(0,0,0)
		return true
	end
	
	
	def needs_cursor?
		return true
	end
end

GameWindow.instance.show
