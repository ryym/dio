# frozen_string_literal: true

require 'spec_helper'

class NumService
  include Dio
  injectable

  def x2(n)
    n * 2
  end
end

class Sample
  include Dio

  inject do |dio|
    @num = dio.load(NumService)
  end

  def double(n)
    @num.x2(n)
  end
end

describe Dio do
  it 'enables to inject dependency' do
    sample = Dio.create(Sample)
    expect(sample.double(10)).to eq(20)
  end

  context 'when loading object which has dependencies' do
    it 'injects dependencies to loaded object' do
      expect(Dio.create(A).a).to eq('abc')
    end

    class A
      include Dio
      inject do |dio|
        @b = dio.load(B)
      end

      def a
        "a#{@b.b}"
      end
    end

    class B
      include Dio
      injectable
      inject do |dio|
        @c = dio.load(C)
      end

      def b
        "b#{@c.c}"
      end
    end

    class C
      include Dio
      injectable

      def c
        'c'
      end
    end
  end
end
