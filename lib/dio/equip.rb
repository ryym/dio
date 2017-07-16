# frozen_string_literal: true

module Dio
  #:nodoc:
  module Equip
    def self.equip_dio(injector_id:, state:, base_module: Module.new, injector: nil)
      state.register_injector(injector_id, injector)
      base_module.tap do |m|
        m.extend(ActiveSupport::Concern)
        m.extend(Dio::ModuleBase)
        m.instance_variable_set(:@state, state)
        m.instance_variable_set(:@injector_id, injector_id)
      end
    end

    def self.use(injector_id, injector = nil)
      equip_dio(
        injector_id: injector_id,
        state: @state,
        base_module: Module.new,
        injector: injector,
      )
    end
  end
end
