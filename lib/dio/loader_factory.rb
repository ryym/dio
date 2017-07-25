# frozen_string_literal: true

require 'dio/load_context'

module Dio
  # LoaderFactory creates Loader.
  # This also allows you to customize dependency loading.
  class LoaderFactory
    def initialize
      @wrappers = {}
    end

    def create(container, target)
      loader = loader_for(target, container)
      Loader.new(loader)
    end

    # Registers a process which wraps loading.
    # Wrappers are run only when a given class is a target of injection.
    #
    # @param clazz [Class]
    # @param wrapper [Block]
    # @yield Dio::LoadContext
    # @example
    #   Dio.wrap_load(UsersController) do |ctx|
    #     puts "loaded: #{ctx.key}"
    #     ctx.load
    #   end
    def wrap_load(clazz, &wrapper)
      @wrappers[clazz] = wrapper
    end

    # Registers a mock dependencies for a given class.
    # When a registered dependency is loaded,
    # the mock is returned instead of the actual one.
    # This uses {#wrap_load} internally.
    #
    # @param clazz [Class]
    # @param deps [Hash]
    def stub_deps(clazz, deps)
      wrap_load(clazz) do |ctx|
        dep = deps[ctx.key]
        return ctx.load unless dep
        dep.respond_to?(:is_a?) && dep.is_a?(Proc) ? dep.call(*ctx.args) : dep
      end
    end

    # Removes load wrappers registered via {#wrap_load} or {#stub_deps}.
    # If you specify a class, only the wrappers for the class are removed.
    #
    # @param clazz [Class]
    def reset_loader(clazz = nil)
      return @wrappers.delete(clazz) if clazz
      @wrappers = {}
      nil
    end
    alias clear_stubs reset_loader

    private

    def loader_for(target, container)
      actual_loader = container.method(:load)
      wrapper = @wrappers[target.class]
      return actual_loader unless wrapper

      lambda { |key, *args|
        context = LoadContext.new(key, target, args, actual_loader)
        wrapper.call(context)
      }
    end

    # Loader just loads a dependency.
    class Loader
      def initialize(loader)
        @loader = loader
      end

      # @see Dio::Container#load
      def load(key, *args)
        @loader.call(key, *args)
      end
    end
  end
end
