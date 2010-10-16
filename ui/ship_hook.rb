module RubyWars
module UI

  class ShipHook
  
    def initialize(ship_ui, ship)
      @ship_ui, @ship = ship_ui, ship
    end

    def update
      @ship_ui.x = @ship.x * 32
      @ship_ui.y = @ship.y * 32
      @ship_ui.life = @ship.hull

      @ship_ui.thrust_forward if @ship.has_thrusted_forward
#        @ship_ui.thrust_right if comm[0] == 'thrust_right'
#        @ship_ui.thrust_left if comm[0] == 'thrust_left'
      @ship.has_thrusted_forward = false

    end

  end
  
end
end
