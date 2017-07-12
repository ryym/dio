# frozen_string_literal: true

module Dio
  # ModuleBase implements core interface methods of Dio.
  module ModuleBase
    extend ActiveSupport::Concern

    def inject(target)
      @injector.inject(target)
    end

    def create(clazz, *args)
      @injector.create(clazz, *args)
    end

    def included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end

    module InstanceMethods # rubocop:disable Style/Documentation
      def __dio_inject__(loader)
        instance_exec loader, &self.class.__dio_injector__
      end
    end

    module ClassMethods # rubocop:disable Style/Documentation
      def injectable(subkey = nil, &block)
        key = subkey ? [self, subkey] : self
        factory = block || ->(*args) { new(*args) }
        Dio.default_injector.register(key, &factory)
      end

      def provide(key, &factory)
        raise "You must define a factory of #{key}" unless block_given?
        Dio.default_injector.register(key, &factory)
      end

      def inject(&injector)
        @__dio_injector__ = injector
      end

      def __dio_injector__
        @__dio_injector__
      end
    end
  end
end
