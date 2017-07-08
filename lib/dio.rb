# frozen_string_literal: true

require 'dio/container'

# rubocop:disable Style/ClassVars

# Dio provides DI functionality.
module Dio
  extend ActiveSupport::Concern

  @@container = Dio::Container.new

  def self.inject(obj)
    @@container.inject(obj)
  end

  def __dio_inject__(container)
    return unless defined? @@__dio_inject__
    instance_exec container, &@@__dio_inject__
  end

  class_methods do
    def be_injectable
      # TODO: User can define the key and its factory block.
      @@container.register(self) { |*args| new(*args) }
    end

    def inject(&injector)
      @@__dio_inject__ = injector
    end
  end
end
