module RubyWars
module Engine

  class System
    
    SMALL, MEDIUM, BIG = [40, 30], [80, 60], [160, 120]
    
    def initialize(name = 'Unnamed System', size = SMALL)
      @fleets = []
      @global_positions = {}
      @name, @size = name, size
    end
   
    # ---- to be overwritten
    
    def size
      @size
    end
    
    def name
      @name
    end
   
    # ---- actions
    
    def deploy_fleet(fleet_builder)
      fleet = fleet_builder.create_fleet(self)
      #TODO check whether the locations are valid against the universe
      x_base = rand(size[0] - 1)
      y_base = rand(size[1] - 1)
      
      ships_array = []
      fleet.each do |ship| 
        @global_positions[ship[:ship]] = { :location => [x_base + ship[:location][0], y_base + ship[:location][1]],
                                           :heading => ship[:heading] }
        ships_array.push ship[:ship]
      end
      @fleets.push(ships_array)
    end
    
    
    def lock(ship, location_target)
      #TODO
    end
    
    # ---- informational
    
    def location(ship)
      @global_positions[ship][:location]
    end
    
    def velocity(ship)
      #TODO
    end
    
    def heading(ship)
      @global_positions[ship][:heading]
    end

    def fleet_members(ship)
      fleet_num = nil
      @fleets.each_with_index do |fleet, i|
        if fleet.select {|v| v == ship}.size != 0
          fleet_num = i
          break
        end
      end
      if fleet_num.nil?
        nil?
      else
        @fleets[fleet_num]
      end
    end
 
    def send_msg(from_ship, to_ship, msg, msg_content = nil)
      to_ship = [to_ship] unless to_ship.is_a?Array
      to_ship.each do |target_ship|
        if fleet_members(from_ship) != fleet_members(target_ship)
          from_ship.sensor_input(:msg_not_sent, {:recipient => target_ship, :msg => msg, :msg_content => msg_content})
        else
          target_ship.msg_received(from_ship, msg, msg_content) if from_ship != target_ship
        end
      end
    end
    
    # --- tick
    
    def tick
      @fleets.each do |fleet|
        fleet.each do |ship|
          ship.tick_sensors
          ship.tick
        end
      end
    end
    
  end

end
end
