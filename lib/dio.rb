# frozen_string_literal: true

require 'active_support/concern'
require 'dio/equip'

# Dio provides DI functionality.
module Dio
  # Create default global state to allow to use Dio features without any setup.
  Equip.equip_dio(injector_id: :default, base_module: self)

  def self.use(injector_id, injector = nil)
    Equip.equip_dio(
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
