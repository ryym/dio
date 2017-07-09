# frozen_string_literal: true

module Dio
  # Loader is a proxy of Container#load.
  class Loader
    def initialize(container, target)
      @container = container
      @target = target
    end

    def load(key, *args)
      @container.load(key: key, target: @target, args: args)
    end
  end
end
