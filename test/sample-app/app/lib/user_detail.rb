# UserDetail fetches some detail data
# about users from a remote server.
class UserDetail
  include Dio

  injectable

  injectable :pattern_b do
    new("access-key-B")
  end

  Data = Struct.new(:key, :data)

  def initialize(access_key)
    @access_key = access_key
  end

  def fetch_detail(user)
    Data.new(@access_key, "Detail of #{user.name} / #{@access_key}.")
  end
end
