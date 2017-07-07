# frozen_string_literal: true

require 'dio'

module Dio
  module Rails
    module Controller
      extend ActiveSupport::Concern
      include Dio

      included do
        before_action do
          Dio.inject(self)
        end
      end
    end
  end
end
