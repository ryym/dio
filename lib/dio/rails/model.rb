# frozen_string_literal: true

require 'dio'

module Dio
  module Rails
    # Dio::Rails::Model enables to inject dependencies to
    # Rails models.
    module Model
      extend ActiveSupport::Concern
      include Dio

      included do
        after_initialize do |model|
          Dio.inject(model)
        end
      end
    end
  end
end
