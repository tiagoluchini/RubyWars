module RubyWars
module UI

  class Ship
  
    IDLE_SHIP, FORWARD_THRUST, RIGHT_THRUST, LEFT_THRUST = *0..3

    attr_reader :x, :y
    attr_accessor :life
    
    def initialize(window, fleet_id)
      @window = window
      @x = @y = @vel_x = @vel_y = @vel_angle = @angle = 0.0
      @life = 1.0
      @anim_id = IDLE_SHIP
      @has_thrusted = @selected = false

      fleet_id += 1
      @color = Gosu::Color.new(0xff000000)
      @color.red = (fleet_id & 1 == 1) ? 255 : 0
      @color.green = (fleet_id & 2 == 2) ? 255 : 0
      @color.blue = (fleet_id & 4 == 4) ? 255 : 0

      @ship_anim = window.res.retrieve(:ship_anim)
      @hull_anim = window.res.retrieve(:hull_anim)
      @fleet_marker = window.res.retrieve(:fleet_marker)
    end

    def warp(x, y)
      @x, @y = x, y
    end
    
    def select
      @selected = true
    end
    
    def unselect
      @selected = false
    end
    
    def thrust_left
      @vel_angle -= 1.5
      thrust(LEFT_THRUST)
    end
    
    def thrust_right
      @vel_angle += 1.5
      thrust(RIGHT_THRUST)
    end
    
    def thrust_forward
      @vel_x += Gosu::offset_x(@angle, 0.5)
      @vel_y += Gosu::offset_y(@angle, 0.5)
      thrust(FORWARD_THRUST)
    end
    
    def move
      @x += @vel_x
      @y += @vel_y
      @angle += @vel_angle

      #TODO: should wrap?
      @x %= 1280
      @y %= 960
      
      #TODO: energy losses? should have? should come from universe at least
      @vel_x *= 0.95
      @vel_y *= 0.95
      @vel_angle *= 0.90
      
      @anim_id = IDLE_SHIP unless @has_thrusted
      @has_thrusted = false
      
    end

    def draw
      #DEBUG: clickable area - @window.draw_quad(@x-16, @y-16, Gosu::Color::YELLOW, @x + 16, @y-16, Gosu::Color::YELLOW, @x-16, @y+16, Gosu::Color::YELLOW, @x+16, @y+16, Gosu::Color::YELLOW )
      draw_life
      @fleet_marker.draw(@x+8, @y-16, ZOrder::ShipMarkers, 1, 1, @color, :additive)
      @ship_anim[@anim_id].draw_rot(@x, @y, ZOrder::Ships, @angle, 0.5, 0.38, 1, 1)
    end
    
    private 
    
      def thrust(anim_id)
        @anim_id = anim_id
        @has_thrusted = true      
      end
      
      def draw_life
        l_color = Gosu::Color::YELLOW
        d_color = Gosu::Color::RED
        l_size = 32 * @life
        l = [[@x-16+(32-l_size), @y+26], [@x+16, @y+26], [@x-16+(32-l_size), @y+26+3], [@x+16, @y+26+3]]
        d = [[@x-16, @y+26], [@x+16-l_size, @y+26], [@x-16, @y+26+3], [@x+16-l_size, @y+26+3]]
        @window.draw_quad(l[0][0],l[0][1], l_color, l[1][0],l[1][1], l_color, l[2][0],l[2][1], l_color, l[3][0],l[3][1], l_color, ZOrder::ShipMarkers)
        @window.draw_quad(d[0][0],d[0][1], d_color, d[1][0],d[1][1], d_color, d[2][0],d[2][1], d_color, d[3][0],d[3][1], d_color, ZOrder::ShipMarkers)
      end
    
  end
  
end
end
