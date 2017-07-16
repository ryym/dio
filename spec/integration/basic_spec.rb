# frozen_string_literal: true

require 'spec_helper'

class A
  include Dio
  injectable

  def a
    :a
  end
end

class B
  include Dio
  injectable :b2

  def b
    :b
  end
end

class C
  include Dio

  inject do |dio|
    @a = dio.load(A)
    @b = dio.load([B, :b2])
  end

  def check
    [@a.a, @b.b]
  end
end

describe 'Basic Dio usage' do
  it 'enables to inject dependency' do
    c = Dio.create(C)
    expect(c.check).to eq([:a, :b])
  end
end
