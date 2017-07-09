class User < ApplicationRecord
  include Dio::Rails::Model

  inject do |dio|
    @age = dio.load(AgeCalculator)
  end

  def age
    @age.from_birthday(birthday)
  end
end
