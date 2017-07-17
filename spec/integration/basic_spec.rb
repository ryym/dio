# frozen_string_literal: true

require 'spec_helper'

describe 'Basic Dio usage' do
  it 'enables to inject dependency' do
    a_class = Class.new do
      include Dio
      injectable

      def a
        :a
      end
    end

    b_class = Class.new do
      include Dio
      injectable :b2

      def b
        :b
      end
    end

    c_class = Class.new do
      include Dio

      inject do |dio|
        @a = dio.load(a_class)
        @b = dio.load([b_class, :b2])
      end

      def check
        [@a.a, @b.b]
      end
    end

    c = Dio.create(c_class)
    expect(c.check).to eq(%i[a b])
  end
end
