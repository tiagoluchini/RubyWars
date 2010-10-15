module RubyWars
module Engine
module Units

  class Parsec

    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def to_au
      AU.new(@value * 206265.0)
    end
    
    def to_light_year
      LightYear.new(@value * 3.26 * 206265.0)
    end

  end
  
end
end
end
