module RubyWars
module UI

  class ResourceManager
  
    def initialize(window)
      @window = window
      @cache = {}
    end
    
    def load(id, resource, border = false)
      @cache[id] = Gosu::Image.new(@window, resource, border)
    end
    
    def load_tiles(id, resource, x, y, border = false)
      @cache[id] = Gosu::Image::load_tiles(@window, resource, x, y, border)
    end

    def retrieve(id)
      @cache[id]
    end
  
  end

end
end

