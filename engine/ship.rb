module RubyWars
module Engine


  class Ship
    include Engine::Modules
    
    MAXIMUM_NUMBER_OF_SLOTS = 5

    LOW_HULL_LEVEL = 0.4
    CRITICAL_HULL_LEVEL = 0.1

    attr_accessor :x, :y, :heading
    
    def initialize(system)
      @system = system
      @modules, @commands = [], []
      @hull = 1.0
      @lock = nil
    end
    
    # ---- informational
    
    def location
      [@x, @y, @heading]
    end
    
    def velocity
      @system.velocity(self)
    end
    
    def hull
      @hull
    end
    
    def modules
      @modules
    end
    
    def fleet_members
      @system.fleet_members(self)
    end
        
    # ---- actions

    def plug_module(in_modules)
      in_modules = [in_modules] unless in_modules.is_a?Array
      raise 'Cannot plug more modules. All slots occupied.' if @modules.size + in_modules.size > MAXIMUM_NUMBER_OF_SLOTS
      in_modules.each {|i| @modules.push i}
    end    

    def activate_module(module_id, command = 'activate', params = nil)
      @commands[module_id] = [command, params]
    end

    def exec_commands
      @commands.each_with_index do |comm, mod_id|
        @modules[mod_id].send(comm[0], comm[1]) unless comm[1].nil?
        @modules[mod_id].send(comm[0]) if comm[1].nil?
      end
      @commands = []
    end   

    def send_msg(recipient, msg, msg_content = nil)
      @system.send_msg(self, recipient, msg, msg_content)
    end
    
    def broadcast_msg(msg, msg_content = nil)
      @system.send_msg(self, fleet_members, msg, msg_content)
    end
    
    def lock_enemy(location)
      @lock = @system.lock(self, location)
    end
    
    def release_lock
      @lock = nil
    end
    
    
    # ---- external events
    
    def damage(damage_points)
      @hull -= damage_points
      sensor_input(:hull_damage)
    end
        
    def tick_sensors
      sensor_input(:low_hull_level) if @hull < LOW_HULL_LEVEL && @hull > CRITICAL_HULL_LEVEL
      sensor_input(:critical_hull_level) if @hull < CRITICAL_HULL_LEVEL
      sensor_input(:lock_location, @lock.location) if @lock
    end

    def enemy_detected(location)
      sensor_input(:enemy_detected, location)
    end
    
    def friend_detected(location)
      sensor_input(:friend_detected, location)
    end

    
    # ---- events to be overwritten
    
    def msg_received(from, msg, msg_content = nil)
      raise 'Method must be overwritten.'
    end
    
    def sensor_input(sensor, sensor_content = nil)
      raise 'Method must be overwritten.'
    end

    def tick
      raise 'Methoid myst be overwritten.'
    end
     
  end


end
end
