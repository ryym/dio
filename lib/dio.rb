# frozen_string_literal: true

require 'dio/provider'

# Dio provides DI functionality.
module Dio
  extend ActiveSupport::Concern

  @provider = Dio::Provider.new

  def self.inject(target)
    unless target.respond_to?(:__dio_inject__)
      raise 'The given object does not include Dio module'
    end
    loader = Loader.new(@provider, target)
    target.__dio_inject__(loader)
    target
  end

  def self.default_provider
    @provider
  end

  def self.wrap_load(&loader)
    @provider.wrap_load(&loader)
  end

  def self.clear_wrap_loads
    @provider.clear_wrap_loads
  end

  def self.override(alts)
    @provider.override(alts)
  end

  def self.remove_overrides
    @provider.remove_overrides
  end

  def __dio_inject__(loader)
    instance_exec loader, &self.class.__dio_injector__
  end

  class_methods do
    def injectable(subkey = nil, &block)
      key = subkey ? [self, subkey] : self
      factory = block || lambda { |*args| new(*args) }
      Dio.default_provider.register(key, &factory)
    end

    def inject(&injector)
      @__dio_injector__ = injector
    end

    def __dio_injector__
      @__dio_injector__
    end
  end
end
