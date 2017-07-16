# frozen_string_literal: true

require 'active_support/concern'
require 'dio/module_base'
require 'dio/state'

# Dio provides DI functionality.
module Dio
  def self.equip_dio(injector_id:, state:, base_module: Module.new, injector: nil)
    state.register_injector(injector_id, injector)
    base_module.tap do |m|
      m.extend(ActiveSupport::Concern)
      m.extend(Dio::ModuleBase)
      m.instance_variable_set(:@state, state)
      m.instance_variable_set(:@injector_id, injector_id)
    end
  end
  private_class_method :equip_dio

  # Create default global state to allow to use Dio features without any setup.
  equip_dio(injector_id: :default, state: Dio::State.new, base_module: self)

  def self.use(injector_id, injector = nil)
    equip_dio(
      injector_id: injector_id,
      state: @state,
      base_module: Module.new,
      injector: injector,
    )
  end

  def self.default_injector
    injector
  end

  def self.wrap_load(&loader)
    injector.wrap_load(&loader)
  end

  def self.clear_wrap_loads
    injector.clear_wrap_loads
  end

  def self.override(alts)
    injector.override(alts)
  end

  def self.remove_overrides
    injector.remove_overrides
  end

  def self.with(deps)
    injector.with(deps)
  end
end
