module RubyWars
module TestImpl

  include RubyWars::Engine

  class TestFleetBuilder < FleetBuilder

    def create_fleet(system)
      [{:ship => TestShip.new(system), :location => [0,0], :heading => 90},
       {:ship => TestShip.new(system), :location => [10,0], :heading => 90}]
    end

  end

end
end
