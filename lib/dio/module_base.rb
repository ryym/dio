# frozen_string_literal: true

module Dio
  # Dio::ModuleBase provides core methods as a mixin.
  # {Dio} module extends this module so you can use all of the methods
  # from Dio like `Dio.injector`.
  module ModuleBase
    extend ActiveSupport::Concern

    # NOTE: A module who extends ModuleBase must define
    # `@state` and @injector_id as class instance variables.

    # Returns a injector associated with this module.
    # If you call `Dio.injector`, it returns a default injector.
    # If an ID is given, returns an injector of the ID.
    #
    # @param id [Symbol]
    # @return [Dio::Injector]
    def injector(id = nil)
      @state.injector(id || @injector_id)
    end

    # Injects dependencies using the injector this module has.
    #
    # @see
    #   Dio::Injector#inject
    def inject(target)
      injector.inject(target)
    end

    # Create an instance of the given class with injection.
    #
    # @see
    #   Dio::Injector#create
    def create(clazz, *args)
      injector.create(clazz, *args)
    end

    # Reset a whole state.
    # This is used mainly for tests.
    def reset_state
      @state.reset(@injector_id => Dio::Injector.new)
    end

    # @see Dio::Injector#wrap_load
    def wrap_load(clazz, &wrapper)
      injector.wrap_load(clazz, &wrapper)
    end

    # @see Dio::Injector#stub_deps
    def stub_deps(clazz, deps)
      injector.stub_deps(clazz, deps)
    end

    # @see Dio::Injector#reset_loader
    def reset_loader(clazz = nil)
      injector.reset_loader(clazz)
    end

    # @see Dio::Injector#clear_stubs
    def clear_stubs(clazz = nil)
      injector.clear_stubs(clazz)
    end

    # Add some methods to a class which includes Dio module.
    def included(base)
      my_injector = injector
      injector_holder = Module.new do
        define_method :__dio_injector__ do
          my_injector
        end
      end
      base.extend(ClassMethods, injector_holder)
      base.include(InstanceMethods)
    end

    # InstanceMethods defines instance methods for classes using Dio.
    module InstanceMethods
      def __dio_inject__(loader)
        injection_proc = self.class.__dio_injection_proc__
        instance_exec loader, &injection_proc if injection_proc
      end
    end

    # ClassMethods defines class methods for classes using Dio.
    module ClassMethods
      # Declares the class is an injectable via Dio.
      # You can define a factory block.
      #
      # @param subkey [Symbol, nil]
      # @yield passed arguments when loading
      def injectable(subkey = nil, &block)
        key = subkey ? [self, subkey] : self
        factory = block || ->(*args) { new(*args) }
        __dio_injector__.register(key, &factory)
      end

      # Registers a factory of a dependency.
      #
      # @param key [Symbol]
      # @yield passed arguments when loading
      def provide(key, &factory)
        raise "You must define a factory of #{key}" unless block_given?
        __dio_injector__.register(key, &factory)
      end

      # Defines a block to load dependencies from Dio.
      # A given block is evaluated in each instance context of the class.
      #
      # @yield [Dio::LoaderFactory::Loader]
      def inject(&injector)
        @__dio_injection_proc__ = injector
      end

      def __dio_injection_proc__
        @__dio_injection_proc__
      end
    end
  end
end
