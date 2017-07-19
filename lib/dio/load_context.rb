# frozen_string_literal: true

module Dio
  # LoadContext provides information for Container's `before_load` hooks.
  class LoadContext
    attr_reader :key, :target, :args

    def initialize(key, target, args, loader)
      @key = key
      @target = target
      @args = args
      @loader = loader
    end

    def load(*args)
      next_args = args.any? ? args : @args
      @loader.call(*next_args)
    end
  end
end
