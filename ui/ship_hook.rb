module RubyWars
module UI

  class ShipHook
  
    def initialize(ship_ui, ship)
      @ship_ui, @ship = ship_ui, ship
    end

    def update
      @ship_ui.x = @ship.x * 32
      @ship_ui.y = @ship.y * 32
      @ship_ui.angle = @ship.heading
      @ship_ui.life = @ship.hull

      @ship_ui.thrust_forward if @ship.has_thrusted_forward
      @ship_ui.thrust_right if @ship.has_thrusted_right
      @ship_ui.thrust_left if @ship.has_thrusted_left
      @ship.has_thrusted_forward = @ship.has_thrusted_right = @ship.has_thrusted_left = false

    end

  end
  
end
end
