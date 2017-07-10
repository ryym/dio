# AgeCalculator calculates an age.
class AgeCalculator
  include Dio

  injectable

  def initialize(now = Time.zone.now)
    @now = now
  end

  def from_birthday(date)
    @now.year - date.year
  end
end
