# frozen_string_literal: true

module Dio
  # Dio::ModuleBase provides core methods as a mixin.
  module ModuleBase
    extend ActiveSupport::Concern

    def injector(id = nil)
      @state.injector(id || @injector_id)
    end

    def inject(target)
      injector.inject(target)
    end

    def create(clazz, *args)
      injector.create(clazz, *args)
    end

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

    module InstanceMethods # rubocop:disable Style/Documentation
      def __dio_inject__(loader)
        injection_proc = self.class.__dio_injection_proc__
        instance_exec loader, &injection_proc if injection_proc
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
