# AgeCalculator calculates an age.
class AgeCalculator
  include Dio

  be_injectable

  def from_birthday(date)
    Time.zone.now.year - date.year
  end
end
