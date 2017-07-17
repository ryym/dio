# frozen_string_literal: true

require 'spec_helper'

describe 'Provider class' do
  it 'enables to provide various dependencies by one class' do
    Class.new do
      include Dio
      provide :greet { 'hello' }
      provide :reversed { |*args| args.reverse }
      provide :filtered_hash { |a:, c:, **_rest| { a: a, c: c } }
    end

    target_class = Class.new do
      include Dio

      inject do |dio|
        @hello = dio.load(:greet)
        @cba = dio.load(:reversed, :a, :b, :c)
        @hash = dio.load(:filtered_hash, a: 1, b: 2, c: 3)
      end

      def check
        { greet: @hello, reversed: @cba, filtered_hash: @hash }
      end
    end

    target = Dio.create(target_class)
    expect(target.check).to eq(
      greet: 'hello',
      reversed: %i[c b a],
      filtered_hash: { a: 1, c: 3 },
    )
  end
end
