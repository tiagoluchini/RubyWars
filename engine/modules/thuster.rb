module RubyWars
module Engine
module Modules

  class Thruster

    def initialize(ship)
      @ship = ship
      @vel_x = @vel_y = @vel_angle = 0.0
    end
    
    def thrust_forward
      @vel_x += Gosu::offset_x(@ship.heading, 0.5)
      @vel_y += Gosu::offset_y(@ship.heading, 0.5)
    end
    
    def thrust_right
    end
    
    def thrust_left
    end
    
    def affect_ship_state
    end

    def tick
      @ship.x += @vel_x
      @ship.y += @vel_y
      @ship.heading += @vel_angle

      #TODO: should wrap?
#      @x %= 1280
#      @y %= 960
      
      #TODO: energy losses? should have? should come from universe at least
      @vel_x *= 0.95
      @vel_y *= 0.95
      @vel_angle *= 0.90
    end
    
  end

end
end
end
