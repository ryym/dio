# frozen_string_literal: true

module Dio
  # ModuleBase implements core interface methods of Dio.
  module ModuleBase
    extend ActiveSupport::Concern

    # @injector is defined in a module that extends ModuleBase.

    def inject(target)
      @injector.inject(target)
    end

    def create(clazz, *args)
      @injector.create(clazz, *args)
    end

    def included(base)
      injector = @injector
      injector_holder = Module.new do
        define_method :__dio_injector__ do
          injector
        end
      end
      base.extend(ClassMethods, injector_holder)
      base.include(InstanceMethods)
    end

    module InstanceMethods # rubocop:disable Style/Documentation
      def __dio_inject__(loader)
        instance_exec loader, &self.class.__dio_injection_proc__
      end
    end

    module ClassMethods # rubocop:disable Style/Documentation
      def injectable(subkey = nil, &block)
        key = subkey ? [self, subkey] : self
        factory = block || ->(*args) { new(*args) }
        __dio_injector__.register(key, &factory)
      end

      def provide(key, &factory)
        raise "You must define a factory of #{key}" unless block_given?
        __dio_injector__.register(key, &factory)
      end

      def inject(&injector)
        @__dio_injection_proc__ = injector
      end

      def __dio_injection_proc__
        @__dio_injection_proc__
      end
    end
  end
end
