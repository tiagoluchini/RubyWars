module RubyWars
module Engine
module Modules

  class Thruster

    def initialize(ship)
      @ship = ship
      @ship.vel_x = @ship.vel_y = @ship.vel_turning = 0.0
    end
    
    def thrust_forward
      @ship.vel_x += Gosu::offset_x(@ship.heading, 0.015)
      @ship.vel_y += Gosu::offset_y(@ship.heading, 0.015)
      @ship.has_thrusted_forward = true
    end
    
    def thrust_right
      #TODO turn right
    end
    
    def thrust_left
      #TODO turn left
    end
    
    def tick
      @ship.x += @ship.vel_x
      @ship.y += @ship.vel_y
      @ship.heading += @ship.vel_turning
    end
    
  end

end
end
end
