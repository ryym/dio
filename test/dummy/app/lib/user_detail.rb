# UserDetail fetches some detail data
# about users from a remote server.
class UserDetail
  Data = Struct.new(:key, :data)

  def initialize(access_key)
    @access_key = access_key
  end

  def fetch_detail(user)
    Data.new(@access_key, "Detail about #{user.name}.")
  end
end