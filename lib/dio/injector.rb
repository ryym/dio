# frozen_string_literal: true

require 'forwardable'
require 'dio/provider'
require 'dio/loader_factory'

module Dio
  # Injector executes dependency injection.
  class Injector
    extend Forwardable

    def_delegators :@provider, :registered?
    def_delegators :@loader_factory, :wrap_load, :stub_deps, :reset_loader, :clear_stubs

    def initialize(provider = Dio::Provider.new, loader_factory = Dio::LoaderFactory.new)
      @provider = provider
      @loader_factory = loader_factory
      @original_provider = nil
    end

    def register(key, object = nil)
      assert_register_args_valid(object, block_given?)
      @provider.register(key) do |*args|
        object = yield(*args) if block_given?
        injectable?(object) ? inject(object) : object
      end
    end

    def inject(target)
      unless injectable?(target)
        raise ArgumentError, 'The given object does not include Dio module'
      end
      loader = @loader_factory.create(@provider, target)
      target.__dio_inject__(loader)
      target
    end

    def create(clazz, *args)
      raise ArgumentError, "#{clazz} is not a class" unless clazz.is_a?(Class)
      inject(clazz.new(*args))
    end

    private

    def assert_register_args_valid(object, block_given)
      return if (object || block_given) && !(object && block_given)
      raise ArgumentError, 'You must specify either an object OR a block'
    end

    def injectable?(object)
      object.respond_to?(:__dio_inject__)
    end
  end
end
