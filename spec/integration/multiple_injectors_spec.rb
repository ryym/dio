# frozen_string_literal: true

require 'spec_helper'

describe 'Multiple injectors' do
  def each_registered?(key, dios)
    dios.map { |dio| dio.injector.registered?(key) }
  end

  it 'enables to use multiple injectors' do
    dio2 = Dio.use(:dio2)

    a_class = Class.new do
      include Dio
      injectable
    end

    b_class = Class.new do
      include dio2
      injectable
    end

    expect(each_registered?(a_class, [Dio, dio2])).to eq([true, false])
    expect(each_registered?(b_class, [Dio, dio2])).to eq([false, true])
  end
end
