require 'test_helper'

class UserTest < ActiveSupport::TestCase
  teardown do
    Dio.clear_before_loads
  end

  test "#age without mock" do
    user = User.new(birthday: Time.zone.local(1997, 3, 10))
    assert(user.age > 0)
    # We can't use `assert_equal` here because `Time.zone.now` is variable.
    # DI solves this problem without using a library such as Timecop.
  end

  test "#age with mock" do
    # TODO: Replace more simply
    Dio.before_load do |ctx|
      return ctx.next unless ctx.target.is_a?(User) && ctx.key == AgeCalculator
      AgeCalculator.new(Time.zone.local(2020, 1, 1))
    end
    user = User.new(birthday: Time.zone.local(2000, 3, 10))
    assert_equal(20, user.age)
  end
end
