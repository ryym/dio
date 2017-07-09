# frozen_string_literal: true

require 'dio/container'
require 'dio/load_context'

module Dio
  # Provider loads dependencies and allows you to hook
  # some processes before/after loading.
  class Provider
    def initialize(container = Container.new)
      @container = container
      @overrides = Container.new
      @loaders = []
    end

    def register(key, &factory)
      @container.register(key, &factory)
    end

    def load(key:, target: nil, args: [])
      return nil unless @container.registered?(key)

      actual_loader = @container.factory(key)
      loader_chain = chain_loaders(key, target, actual_loader)
      loader_chain.call(*args)
    end

    def wrap_load(&loader)
      @loaders.unshift(loader)
    end

    def clear_wrap_loads
      @loaders = []
    end

    def override(alts)
      alts.each do |key, factory|
        @overrides.register(key, &factory)
      end
    end

    def remove_overrides
      @overrides = Container.new
    end

    private

    def overriding_loader
      lambda do |ctx|
        if @overrides.registered?(ctx.key)
          next @overrides.load(ctx.key, *ctx.args)
        end
        ctx.next
      end
    end

    def chain_loaders(key, target, last_loader)
      loaders = [overriding_loader] + @loaders
      loaders.inject(last_loader) do |next_loader, loader|
        lambda do |*args|
          ctx = LoadContext.new(key, target, args, next_loader)
          loader.call(ctx)
        end
      end
    end
  end
end
