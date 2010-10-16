module RubyWars
module Engine

  class System
  
    attr_reader :fleets
    
    SMALL, MEDIUM, BIG = *0..2
    DIMENSIONS = [[40, 30], [80, 60], [160, 120]]
    
    def initialize(name = 'Unnamed System', size = SMALL)
      @fleets = []
      @name, @size = name, size
    end
   
    # ---- system informational
    
    def size
      @size
    end
    
    def dimensions_in_bu
      DIMENSIONS[@size]
    end
    
    def name
      @name
    end
   
    # ---- actions
    
    def deploy_fleet(fleet_builder)
      fleet_info = fleet_builder.create_fleet(self)
      #TODO check whether the locations are valid against the universe
      x_base = rand(dimensions_in_bu[0] - 1)
      y_base = rand(dimensions_in_bu[1] - 1)
      
      ships_array = []
      fleet_info.each do |ship_info| 
        ship = ship_info[:ship]
        ship.x = x_base + ship_info[:location][0]
        ship.y = y_base + ship_info[:location][1]
        ship.heading = ship_info[:heading]
        ships_array.push(ship)
      end
      @fleets.push(ships_array)
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
    
    def lock(ship, location_target)
      #TODO
    end
    
    
    # ---- ship informational
    
    def velocity(ship)
      #TODO
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
     
    # --- tick
    
    def tick
      @fleets.each do |fleet|
        fleet.each do |ship|
          ship.tick_sensors
          ship.tick
          ship.exec_commands
          ship.modules.each { |mod| mod.tick }
        end
      end
    end
    
  end

end
end
