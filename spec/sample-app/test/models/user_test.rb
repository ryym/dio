require 'test_helper'

class UserTest < ActiveSupport::TestCase
  teardown do
    Dio.clear_stubs
  end

  test "#age without mock" do
    user = User.new(birthday: Time.zone.local(1997, 3, 10))
    assert(user.age > 0)
    # We can't use `assert_equal` here because `Time.zone.now` is variable.
    # DI solves this problem without using a library such as Timecop.
  end

  test "#age with mock" do
    Dio.stub_deps(User, {
      AgeCalculator => AgeCalculator.new(Time.zone.local(2020, 1, 1))
    })

    user = User.new(birthday: Time.zone.local(2000, 3, 10))
    assert_equal(20, user.age)
  end
end
