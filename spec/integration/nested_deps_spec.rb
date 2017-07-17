# frozen_string_literal: true

require 'spec_helper'

describe 'Nested dependency loading' do
  it 'injects dependencies to loaded object' do
    a_class = Class.new do
      include Dio
      injectable

      def a
        :a
      end
    end

    b_class = Class.new do
      include Dio
      injectable

      inject do |dio|
        @a = dio.load(a_class)
      end

      def b
        [:b, @a.a]
      end
    end

    c_class = Class.new do
      include Dio
      injectable

      inject do |dio|
        @b = dio.load(b_class)
      end

      def c
        [:c, @b.b]
      end
    end

    expect(Dio.create(c_class).c).to eq([:c, %i[b a]])
  end
end
