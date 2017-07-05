# Dio (WIP)

An attempt to introduce Dependency Injection feature to Rails.

## Plan

```ruby
class FooService
  include Dio

  be_injectable

  be_injectable "b-pattern" do
    FooService.new(Settings.b_pattern_key)
  end

  def initialize(key = Settings.access_key)
    @access_key = key
  end

  def fetch_foo(user_id)
    # ...
  end
end

class UsersController
  include Dio::Rails::Controller

  inject do |dio|
    @foo = dio.load(FooService)
  end

  def show
    foo_value = @foo.fetch_foo(params[:id])
    # ...
  end
end

# Inject manually
Dio.inject(@controller, FooService: MockFooService.new)
```

## Motivation

- Where should we place business logic in Rails?
- Even if we decide a place of business logic classes,
  how should we implement and use them?
  As a mixin? Or a singleton class?
- Personally speaking, I want to define a class and instantiate it normally.
  I feel this way is simple and scalable.
- But I don't want to instantiate logic classes directly inside of a class who uses them.
  It makes its test a bit cumbersome.
