# frozen_string_literal: true

require 'dio/container'

# Dio provides DI functionality.
module Dio
  extend ActiveSupport::Concern

  @container = Dio::Container.new

  def self.inject(obj)
    @container.inject(obj)
  end

  def self.default_container
    @container
  end

  def self.before_load(&loader)
    @container.before_load(&loader)
  end

  def self.clear_before_loads
    @container.clear_before_loads
  end

  def __dio_inject__(loader)
    instance_exec loader, &self.class.__dio_injector__
  end

  class_methods do
    def be_injectable
      # TODO: User can define the key and its factory block.
      Dio.default_container.register(self) { |*args| new(*args) }
    end

    def inject(&injector)
      @__dio_injector__ = injector
    end

    def __dio_injector__
      @__dio_injector__
    end
  end
end
