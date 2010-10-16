module RubyWars
module UI

  class SystemStatus
    
    def initialize(window, system)
      @font = Gosu::Font.new(window, Gosu::default_font_name, 20)
      @colors = []
      @window, @system = window, system      
      system.fleets.each_with_index do |fleet, i|
        fleet_id = i + 1
        color = Gosu::Color.new(0xff000000)
        color.red = (fleet_id & 1 == 1) ? 255 : 0
        color.green = (fleet_id & 2 == 2) ? 255 : 0
        color.blue = (fleet_id & 4 == 4) ? 255 : 0
        @colors.push(color)
      end
    end
    
    def draw
      @system.fleets.each_with_index do |fleet, i|
        @window.res.retrieve(:fleet_marker).draw(10, 32 + (i*20), ZOrder::UI, 1, 1, @colors[i], :additive)
        @font.draw("Ships: #{fleet.size} (#{fleet.inject(0.0) {|sum,s| sum + s.hull}})", 22, 30 + (i*20), ZOrder::UI, 1.0, 1.0, @colors[i])
      end
    end

  end
  
end
end
