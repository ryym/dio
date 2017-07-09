# frozen_string_literal: true

module Dio
  # LoadContext provides information for Container's `before_load` hooks.
  class LoadContext
    attr_reader :key, :target, :args

    def initialize(key, target, args, next_loader)
      @key = key
      @target = target
      @args = args
      @next = next_loader
    end

    def next(args: @args)
      @next.call(args: args)
    end
  end
end
