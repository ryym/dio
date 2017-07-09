# frozen_string_literal: true

require 'dio/container'
require 'dio/load_context'

module Dio
  # Provider loads dependencies and allows you to hook
  # some processes before/after loading.
  class Provider
    def initialize(container = Container.new)
      @container = container
      @loaders = []
    end

    def register(key, &factory)
      @container.register(key, &factory)
    end

    def load(key:, target: nil, args: [])
      return nil unless @container.registered?(key)

      actual_loader = make_actual_loader(key)
      loader_chain = chain_loaders(key, target, actual_loader)
      loader_chain.call(args: args)
    end

    def wrap_load(&loader)
      @loaders.unshift(loader)
    end

    def clear_wrap_loads
      @loaders = []
    end

    private

    def make_actual_loader(key)
      lambda do |args:|
        @container.load(key, *args)
      end
    end

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
