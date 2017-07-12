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
end
