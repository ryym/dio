# frozen_string_literal: true

module Dio
  # LoadContext provides some information about current loading.
  class LoadContext
    # @!attribute [r] key
    #   A key of a loaded dependency.
    # @!attribute [r] target
    #   An instance which is injected to.
    # @!attribute [r] args
    #   Passed arguments when loaded.
    attr_reader :key, :target, :args

    def initialize(key, target, args, loader)
      @key = key
      @target = target
      @args = args
      @loader = loader
    end

    # Loads a dependency. You can omit arguments because
    # the LoadContext instance already has arguments for loading.
    #
    # @param args [Array]
    # @return [Object] The dependency object.
    def load(*args)
      next_args = args.any? ? args : @args
      @loader.call(@key, *next_args)
    end
  end
end
