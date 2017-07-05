module Dio
  class Container
    def initialize
      @factories = {}
    end

    def register(key, &factory)
      @factories[key] = factory
    end

    def load(key, *args)
      @factories[key].call(*args)
    end

    def inject(obj)
      obj.__dio_inject__(self)
      obj
    end
  end
end
