# frozen_string_literal: true

module Dio
  # Loader is a proxy of Provider#load.
  class Loader
    def initialize(provider, target)
      @provider = provider
      @target = target
    end

    def load(key, *args)
      @provider.load_with(key: key, target: @target, args: args)
    end
  end
end
