# frozen_string_literal: true

require 'dio/loader'
require 'dio/load_context'

module Dio
  # Container stores dependency key and its factory.
  class Container
    def initialize
      @factories = {}
      @loaders = []
    end

    def register(key)
      @factories[key] = lambda do |args:|
        yield(*args)
      end
    end

    def load(key:, target:, args:)
      return nil unless @factories.key?(key)
      actual_loader = @factories[key]
      loader_chain = chain_loaders(key, target, actual_loader)
      loader_chain.call(args: args)
    end

    def inject(obj)
      unless obj.respond_to?(:__dio_inject__)
        raise 'The given object does not include Dio module'
      end
      obj.__dio_inject__(Loader.new(self, obj))
      obj
    end

    def before_load(&loader)
      @loaders.unshift(loader)
    end

    def clear_before_loads
      @loaders = []
    end

    private

    def chain_loaders(key, target, last_loader)
      @loaders.inject(last_loader) do |next_loader, loader|
        lambda do |args:|
          ctx = LoadContext.new(key, target, args, next_loader)
          loader.call(ctx)
        end
      end
    end
  end
end
