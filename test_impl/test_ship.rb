module RubyWars
module TestImpl

  include Engine

  class TestShip < Ship
  
    def initialize(system)
      super(system)
      plug_module(Thruster.new(self))
      @move_count = 0
    end

    def msg_received(from, msg, msg_content = nil)
      case msg
        when :please_update_locations
          broadcast_msg(:alive, :at => location)
        when :alive
          @friends_location ||= {}
          @friends_location[from] = msg_content[:at]
          puts "#{self} now knows that #{from} is at #{@friends_location[from].inspect}"
      end
    
#      puts "#{self} receiving msg from #{from}"
#      puts "msg: :#{msg.to_s}\nmsg_content: #{msg_content.inspect}"
    end
    
    def sensor_input(sensor, sensor_content = nil)
      puts "sensor: :#{sensor.to_s}\nsensor_content: #{sensor_content}"
    end

    def tick
      #@friends_location_counter ||= 0
      #@friends_location_counter++
      if !defined?@friends_location# or @friends_location_counter > 20
        puts "#{self} don't know my friends locations"
        broadcast_msg(:please_update_locations)
      end
      
      if @move_count < 60 * 10
        r = rand(3)
        case r
          when 0
            activate_module(0, 'thrust_forward')
          when 1
            activate_module(0, 'thrust_right')
          when 2
            activate_module(0, 'thrust_left')
        end
        @move_count += 1
      end
      
    end

  end

end
end
