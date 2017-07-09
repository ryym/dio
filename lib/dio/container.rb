# frozen_string_literal: true

require 'dio/loader'
require 'dio/load_context'

module Dio
  # Container stores dependency key and its factory.
  class Container
    def initialize
      @factories = {}
    end

    def register(key, &factory)
      @factories[key] = factory
    end

    def registered?(key)
      @factories.key?(key)
    end

    def load(key, *args)
      return nil unless registered?(key)
      @factories[key].call(*args)
    end
  end
end
