# frozen_string_literal: true

module Dio
  # Container stores dependency objects.
  class Container
    def initialize(factories = {})
      @factories = factories
    end

    # Registers a dependency factory with a given key.
    # If the key is already used, the previous factory is removed.
    # @param key [Object]
    # @param factory [Block]
    # @return [Dio::Container]
    def register(key, &factory)
      @factories[key] = factory
      self
    end

    # Registers all key value pairs of a given hash as dependencies.
    #
    # @param deps [Hash]
    # @return [Dio::Container]
    # @see Dio::Container#register
    def register_all(deps)
      deps.each do |key, factory|
        register(key, &factory)
      end
      self
    end

    # Return a given key is taken or not.
    #
    # @param key [Object]
    # @return [boolean]
    def registered?(key)
      @factories.key?(key)
    end

    # Returns a factory associated with the given key.
    #
    # @param key [Object]
    # @return [Proc]
    def factory(key)
      @factories[key]
    end

    # Executes a factory of the given key and loads an object.
    #
    # @param key [Object]
    # @param args [Array] They are passed to the factory proc as arguments.
    # @return [Object]
    def load(key, *args)
      @factories[key]&.call(*args)
    end
  end
end
