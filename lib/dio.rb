# frozen_string_literal: true

module Dio
  extend ActiveSupport::Concern

  @@container = Dio::Container.new

  def self.inject(obj)
    @@container.inject(obj)
  end

  def __dio_inject__(dio)
    instance_exec dio, &@@__dio_inject__
  end

  class_methods do
    def be_injectable
      # TODO: User can define the key and its factory block.
      @@container.register(self) { new }
    end

    def inject(&injector)
      @@__dio_inject__ = injector
    end
  end

  included do
    # XXX: Rails Controller specific process.
    if respond_to?(:before_action)
      before_action do
        Dio.inject(self)
      end
    end
  end
end
