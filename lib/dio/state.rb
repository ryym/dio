# frozen_string_literal: true

require 'dio/injector_store'

module Dio
  # Dio::State holds some global states.
  # This is used internally.
  class State
    def initialize(injectors = Dio::InjectorStore.new)
      @injectors = injectors
    end

    def register_injector(id, injector = nil)
      @injectors.register(id, injector)
    end

    # Load an injector from the given ID.
    def injector(id)
      @injectors.load(id)
    end

    # Reset whole states.
    def reset(injectors = {})
      @injectors = Dio::InjectorStore.new(injectors)
    end
  end
end
