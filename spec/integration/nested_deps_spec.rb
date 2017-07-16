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
  injectable

  inject do |dio|
    @a = dio.load(A)
  end

  def b
    [:b, @a.a]
  end
end

class C
  include Dio
  injectable

  inject do |dio|
    @b = dio.load(B)
  end

  def c
    [:c, @b.b]
  end
end

describe 'Nested dependency loading' do
  it 'injects dependencies to loaded object' do
    expect(Dio.create(C).c).to eq([:c, [:b, :a]])
  end
end
