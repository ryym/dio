# frozen_string_literal: true

require 'dio/injector_store'

module Dio
  # Dio::State holds states.
  class State
    def initialize(injectors = Dio::InjectorStore.new)
      @injectors = injectors
    end

    def register_injector(id, injector = nil)
      @injectors.register(id, injector)
    end

    def injector(id)
      @injectors.load(id)
    end
  end
end
