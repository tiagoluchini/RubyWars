module RubyWars
module TestImpl

  include RubyWars::Engine

  class TestFleetBuilder < FleetBuilder

    def create_fleet(system)
      [{:ship => TestShip.new(system), :location => [0,0], :heading => 0.0},
       {:ship => TestShip.new(system), :location => [2,0], :heading => 0.0}]
    end

  end

end
end
