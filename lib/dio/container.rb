# frozen_string_literal: true

module Dio
  # Container stores dependency key and its factory.
  class Container
    def initialize
      @factories = {}
    end

    def register(key, &factory)
      @factories[key] = factory
    end

    def load(key, *args)
      @factories[key]&.call(*args)
    end

    def inject(obj)
      unless obj.respond_to?(:__dio_inject__)
        raise 'The given object does not include Dio module'
      end
      obj.__dio_inject__(self)
      obj
    end
  end
end
