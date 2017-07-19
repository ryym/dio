# frozen_string_literal: true

require 'forwardable'
require 'dio/container'
require 'dio/loader_factory'

module Dio
  # Injector executes dependency injection.
  # You can register and inject dependencies using this class.
  class Injector
    extend Forwardable

    def_delegators :@container, :registered?

    # @!method wrap_load(clazz, &wrapper)
    #   Delagated.
    #   @see Dio::LoaderFactory#wrap_load
    # @!method stub_deps(clazz, deps)
    #   Delagated.
    #   @see Dio::LoaderFactory#stub_deps
    # @!method reset_loader(clazz = nil)
    #   Delagated.
    #   @see Dio::LoaderFactory#reset_loader
    # @!method clear_stubs(clazz = nil)
    #   Delagated.
    #   @see Dio::LoaderFactory#clear_stubs
    def_delegators :@loader_factory, :wrap_load, :stub_deps, :reset_loader, :clear_stubs

    def initialize(container = Dio::Container.new, loader_factory = Dio::LoaderFactory.new)
      @container = container
      @loader_factory = loader_factory
      @original_container = nil
    end

    # Registers a new dependency with the given key.
    # You can specify either an object or a factory block
    # that creates an object.
    #
    # @param key [Object] Typically a class or a symbol.
    # @param object [Object]
    # @yield passed arguments when loading
    # @return [Dio::Injector] self
    def register(key, object = nil)
      assert_register_args_valid(object, block_given?)
      @container.register(key) do |*args|
        object = yield(*args) if block_given?
        injectable?(object) ? inject(object) : object
      end
      self
    end

    # Inject dependencies to the given object.
    #
    # @param target [Object]
    # @return target
    def inject(target)
      unless injectable?(target)
        raise ArgumentError, 'The given object does not include Dio module'
      end
      loader = @loader_factory.create(@container, target)
      target.__dio_inject__(loader)
      target
    end

    # Creates a new instance of the given class.
    # Dio injects dependencies to the created instance.
    #
    # @param clazz [Class]
    # @param args [Array]
    # @return Instance of clazz
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
