module RubyWars
module Engine
module Units

  class BU

    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def to_au
      AU.new(@value/100000)
    end

    def to_parsec
      Parsec.new(@value/100000/206265.0)
    end
    
    def to_light_year
      LightYear.new(@value * 3.26/100000)
    end

  end

end
end
end
