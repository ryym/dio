# frozen_string_literal: true

require 'dio'

module Dio
  module Rails
    # Dio::Rails::Model enables to inject dependencies to
    # Rails models.
    module Model
      extend ActiveSupport::Concern

      DioForModel = Dio.use(:default)
      include DioForModel

      included do
        after_initialize do |model|
          DioForModel.inject(model)
        end
      end
    end
  end
end
