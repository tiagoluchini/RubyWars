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
          apply_damages(ship)
          if ship.hull <= 0.0 then
            fleet.delete(ship)
            break
          end
          ship.tick_sensors
          ship.tick
          ship.exec_commands
          ship.modules.each { |mod| mod.tick }
          apply_energy_losses(ship)
        end
      end
    end
   
    private
    
      def apply_damages(ship)
        if ship.x <= 0.0 or ship.x >= dimensions_in_bu[0]
          ship.damage(ship.vel_x.abs * 5)
          ship.vel_x = 0.0
          ship.x = 0.01 if ship.x <= 0.0
          ship.x = dimensions_in_bu[0] - 0.01 if ship.x >= dimensions_in_bu[0]
        end
        if ship.y <= 0.0 or ship.y >= dimensions_in_bu[1]
          ship.damage(ship.vel_y.abs * 5)
          ship.vel_y = 0.0
          ship.y = 0.01 if ship.y <= 0.0
          ship.y = dimensions_in_bu[1] - 0.01 if ship.y >= dimensions_in_bu[1]
        end
      end
    
      def apply_energy_losses(ship)
        unless in_border?(ship)
          ship.vel_x *= Universe::LINEAR_ENERGY_LOSS
          ship.vel_y *= Universe::LINEAR_ENERGY_LOSS
          ship.vel_turning *= Universe::CENTRIPETAL_ENERGY_LOSS
        else
          ship.vel_x *= Universe::LINEAR_ENERGY_LOSS_AT_BORDER
          ship.vel_y *= Universe::LINEAR_ENERGY_LOSS_AT_BORDER
          ship.vel_turning *= Universe::CENTRIPETAL_ENERGY_LOSS_AT_BORDER
        end
      end 
      
      def in_border?(ship)
        if ship.x <= Universe::BORDER_SIZE_IN_BU or ship.y <= Universe::BORDER_SIZE_IN_BU or
            ship.x >= dimensions_in_bu[0] - Universe::BORDER_SIZE_IN_BU or
            ship.y >= dimensions_in_bu[1] - Universe::BORDER_SIZE_IN_BU
          true
        else
          false
        end
      end
   
  end

end
end
