require 'test_helper'

class UserTest < ActiveSupport::TestCase
  teardown do
    Dio.remove_overrides
  end

  test "#age without mock" do
    user = User.new(birthday: Time.zone.local(1997, 3, 10))
    assert(user.age > 0)
    # We can't use `assert_equal` here because `Time.zone.now` is variable.
    # DI solves this problem without using a library such as Timecop.
  end

  test "#age with mock" do
    Dio.override(
      AgeCalculator => proc {
        AgeCalculator.new(Time.zone.local(2020, 1, 1))
        # Or return a complete mock which responds to `from_birthday`.
      }
    )

    user = User.new(birthday: Time.zone.local(2000, 3, 10))
    assert_equal(20, user.age)
  end

  test "#age with mock more simply" do
    user_attrs = { birthday: Time.zone.local(2005, 1, 1) }

    injector = Dio.with(
      AgeCalculator => proc {
        AgeCalculator.new(Time.zone.local(2020, 1, 1))
      }
    )
    user = injector.create(User, user_attrs)
    assert_equal(15, user.age)

    # The original injector doesn't change.
    user = Dio.create(User, user_attrs)
    assert_equal(Time.zone.now.year - 2005, user.age)
  end
end
