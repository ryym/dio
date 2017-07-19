# frozen_string_literal: true

require 'dio/load_context'

module Dio
  # Provider loads dependencies and allows you to hook
  # some processes before/after loading.
  class Provider
    def initialize(factories = {})
      @factories = factories
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

    def factory(key)
      @factories[key]
    end

    def load(key, *args)
      @factories[key]&.call(*args)
    end
  end
end
