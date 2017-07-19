# Dio

[![Build Status][travis-badge]](https://travis-ci.org/ryym/dio)

[travis-badge]: https://travis-ci.org/ryym/dio.svg?branch=master

Dio is a gem which allows you to do Dependency Injection (DI) in Ruby.
This is mainly made for use with Rails.

## Installation

```bash
$ gem install dio-rails
```

## Usage

### Register injectable objects

You can declare that a class is injectable.

```ruby
class SomeAPI
  include Dio

  # Register a factory block.
  # If you omit a block, `SomeAPI.new` is registered.
  injectable do
    SomeAPI.new(ENV['access-key'])
  end

  # You can register multiple factories.
  injectable :with_custom_key

  def initialize(access_key)
    @access_key = access_key
  end

  def fetch_some
    # ...
  end

  # ...
end
```

Or you can define a provider class.
Note that you need to load this class before injection in this case.

```ruby
class DepsProvider
  include Dio

  provide :foo do |name|
    Foo.new(name: name, type: :default)
  end

  provide :bar do |*args|
    BarFactory.create(*args)
  end

  # ...
end
```

In this provider pattern, you must specify both of a key and a factory block.

### Configure injection

In a class that has dependencies, define a `inject` block and
load dependencies it needs.
`dio.load` runs a factory block registered with the given key.

```ruby
class SomeAction
  include Dio

  # The given block is evaluated in each instance scope so that
  # you can store loaded dependencies as instance variables.
  inject do |dio|
    @api = dio.load(SomeAPI)
    # @api = dio.load([SomeAPI, :with_custom_key], 'custom-access-key')
    @foo = dio.load(:foo, 'my-foo')
  end

  def load_some
    some = @api.fetch_some
    # ...
  end
end
```

### Apply injection

There are two ways to apply injection manually.

```ruby
# Create an instance with injection.
action = Dio.create(SomeAction)

# Or inject to an already created instance.
Dio.inject(action)
```

### Use with Rails

#### Controller

Include `Dio::Rails::Controller` to inject dependencies automatically.

```ruby
class UsersController < ApplicationController
  include Dio::Rails::Controller

  attr_reader :user_detail

  inject do |dio|
    @user_detail = dio.load(UserDetail)
  end

  def show
    @user = User.find(params[:id])
    @detail = user_detail.about(user)
  end
end
```

#### Model

Include `Dio::Rails::Model` to inject dependencies automatically.

```ruby
class User < ApplicationModel
  include Dio::Rails::Model

  inject do |dio|
    @age = dio.load(AgeCalculator)
  end

  def age
    @age.from_birthday(birthday)
  end
end
```

### Testing

You can easily replace depdendencies for testing.

```ruby
class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    Dio.clear_stubs
  end

  test "should get index" do
    UserDetailMock = Class.new do
      def fetch_detail(user)
        UserDetail::Data.new("mock", "mock detail")
      end
    end

    # Pass a hash of key-mock pairs.
    # When you load the key that is in the hash, a registered mock
    # is returned instead of the actual dependency object.
    Dio.stub_deps(UsersController, {
      UserDetail => UserDetailMock.new
    })

    get users_url
    assert_response :success
  end
end
```

## Motivation

- I want to separate logics from Rails controllers.
- I don't want to instantiate a logic class in controllers.
  It makes it a bit cumbersome to use mocks in a test.
- In many cases I want to use a class rather than mixin modules because:
    - Mixin pollutes name space of an includer class.
    - It is difficult to declare a private method in mixin module
      that can't be seen even from an includer class.
    - A class allows us to initialize it with some dependencies it needs.

Dependency injection allows us to separate instantiation of dependencies from a class depending on them.
