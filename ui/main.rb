require 'rubygems'
require 'gosu'

require 'ui/resource_manager.rb'
require 'ui/ship.rb'

module RubyWars
module UI

  module ZOrder
    Background, Ships, UI = *0..3
  end

  class GameWindow < Gosu::Window    

    def initialize
      super(1280, 960, false)
      self.caption = 'RubyWars'
      load_resources


      #TODO hooks with engine
      
      #TODO should be ship (multiple ones)
      @player = Ship.new(self)
      @player.warp(320, 240)
    end

    def res
      @res
    end

    def update
      if button_down? Gosu::Button::KbLeft or button_down? Gosu::Button::GpLeft then
        @player.thrust_left
      end
      if button_down? Gosu::Button::KbRight or button_down? Gosu::Button::GpRight then
        @player.thrust_right
      end
      if button_down? Gosu::Button::KbUp or button_down? Gosu::Button::GpButton0 then
        @player.thrust_forward
      end
      if button_down? Gosu::MsLeft then
        if mouse_x >= @player.x - 16 and mouse_x <= @player.x + 16 and
           mouse_y >= @player.y - 16 and mouse_y <= @player.y + 16 then
          @player.select
        else
          @player.unselect
        end
      end
      @player.move
    end

    def draw
      #TODO scaling depending of "virtual" size
      background_draw
      @player.draw
    end
    
    def button_down(id)

      if id == Gosu::MsLeft then
        puts "Clicked: [#{mouse_x}x#{mouse_y}] - Player: [#{@player.x}x#{@player.y}]" 
      end
      if id == Gosu::KbEscape then
        close
      end
    end

    private 

      def load_resources
        @res = ResourceManager.new(self)
        @res.load(:background, 'ui/media/space.png', true)
        @res.load_tiles(:ship_anim, 'ui/media/ship.png', 32, 42)
        @res.load_tiles(:hull_anim, 'ui/media/hull.png', 40, 40)
      end
      
      def background_draw
        back = @res.retrieve(:background)
        back.draw(0, 0, ZOrder::Background)
        back.draw(640, 0, ZOrder::Background)
        back.draw(0, 480, ZOrder::Background)
        back.draw(640, 480, ZOrder::Background)
      end

  end
  

end
end
