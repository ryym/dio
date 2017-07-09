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

  def __dio_inject__(container)
    instance_exec container, &self.class.__dio_injector__
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
