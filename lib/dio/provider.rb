# frozen_string_literal: true

require 'dio/load_context'

module Dio
  # Provider loads dependencies and allows you to hook
  # some processes before/after loading.
  class Provider
    def initialize(factories = {}, loaders = [])
      @factories = factories
      @loaders = loaders
    end

    def register(key, &factory)
      @factories[key] = factory
      self
    end

    def register_all(deps)
      deps.each do |key, factory|
        register(key, &factory)
      end
      self
    end

    def registered?(key)
      @factories.key?(key)
    end

    def load(key:, target: nil, args: [])
      return nil unless registered?(key)

      actual_loader = @factories[key]
      loader_chain = chain_loaders(key, target, actual_loader)
      loader_chain.call(*args)
    end

    def wrap_load(&loader)
      @loaders.unshift(loader)
      -> { delete_wrap_load(loader) }
    end

    def delete_wrap_load(loader)
      @loaders.delete(loader)
    end

    def clear_wrap_loads
      @loaders = []
    end

    def dup
      Provider.new(@factories.dup, @loaders.dup)
    end

    private

    def chain_loaders(key, target, last_loader)
      @loaders.inject(last_loader) do |next_loader, loader|
        lambda do |*args|
          ctx = LoadContext.new(key, target, args, next_loader)
          loader.call(ctx)
        end
      end
    end
  end
end
