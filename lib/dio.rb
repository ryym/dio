# frozen_string_literal: true

require 'active_support/concern'
require 'dio/equip'
require 'dio/version'

# Dio provides DI functionality.
# Note that most of the methods this module provides are
# defined at {Dio::ModuleBase}.
#
# @see Dio::ModuleBase
# @see Dio::ModuleBase::ClassMethods
module Dio
  # Create default global state to allow to use Dio features without any setup.
  Equip.equip_dio(injector_id: :default, base_module: self)

  # Creates a new Dio module with the specified {Dio::Injector}.
  # You can use several injectors using this method.
  #
  # @param injector_id [Symbol]
  # @param injector [Dio::Injector, nil]
  # @return [Dio::ModuleBase] A module extends Dio::ModuleBase.
  #
  # @example
  #   class Some
  #     include Dio.use(:another_injector)
  #     # ...
  #   end
  def self.use(injector_id, injector = nil)
    Equip.equip_dio(
      injector_id: injector_id,
      state: @state,
      base_module: Module.new,
      injector: injector,
    )
  end

  # Returns a default {Dio::Injector}.
  # By default all dependencies are registered and loaded via this injector.
  # Its injector ID is `:default`.
  #
  # @return [Dio::Injector]
  def self.default_injector
    injector
  end

  # Currently this method does nothing.
  # This method is intended to be used in the following situation.
  #
  # - You use a dependencies provider class
  # - The provider class is autoloadable (you can't `require` it explicitly)
  #
  # In that case, you need to autoload the provider class before using dependencies it provides.
  # You can use this noop method for that purpose.
  #
  # @example
  #   class MyProvider
  #     include Dio
  #
  #     provide :foo { Foo.new }
  #   end
  #
  #   # In another file. You can autoload MyProvider naturally like this.
  #   Dio.depends MyProvider
  #
  #   class UsersController < ApplicationController
  #     include Dio::Rails::Controller
  #
  #     inject do |dio|
  #       @foo = dio.load(:foo)
  #     end
  #   end
  # @see
  #   http://guides.rubyonrails.org/autoloading_and_reloading_constants.html
  def self.depends(*_args); end
end
