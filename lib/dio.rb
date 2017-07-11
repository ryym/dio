# frozen_string_literal: true

require 'dio/injector'

# Dio provides DI functionality.
module Dio
  extend ActiveSupport::Concern

  @injector = Dio::Injector.new

  def self.inject(target)
    @injector.inject(target)
  end

  def self.default_injector
    @injector
  end

  def self.wrap_load(&loader)
    @injector.wrap_load(&loader)
  end

  def self.clear_wrap_loads
    @injector.clear_wrap_loads
  end

  def self.override(alts)
    @injector.override(alts)
  end

  def self.remove_overrides
    @injector.remove_overrides
  end

  def __dio_inject__(loader)
    instance_exec loader, &self.class.__dio_injector__
  end

  class_methods do
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
