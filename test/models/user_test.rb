require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test '.all' do
      User.delete_all
      user = User.new(name: 'Test')
      user.save
      assert_equal(User.all, [user])
  end
end
