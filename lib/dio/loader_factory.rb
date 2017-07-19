# frozen_string_literal: true

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

    def wrap_load(clazz, &wrapper)
      @wrappers[clazz] = wrapper
    end

    def stub_deps(clazz, deps)
      wrap_load(clazz) do |ctx|
        dep = deps[ctx.key]
        return ctx.load unless dep
        dep.is_a?(Proc) ? dep.call(*ctx.args) : dep
      end
    end

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

    # :nodoc:
    class Loader
      def initialize(loader)
        @loader = loader
      end

      def load(key, *args)
        @loader.call(key, *args)
      end
    end
  end
end
