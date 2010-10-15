module RubyWars
module Engine
module Units

  class LightYear

    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def to_au
      AU.new(@value / 3.26)
    end
    
    def to_parsec
      Parsec.new(@value / 3.26 / 206265.0)
    end

  end

end
end
end
