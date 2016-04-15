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
  
  test 'age should be integer' do
      User.delete_all
      user = User.new(name: 'Test', age: 20)
      user.save
      
      user = User.find(user.id)
      assert_equal(user.age.class, Fixnum)
  end
  
  test 'date_of_birth should be date' do
      User.delete_all
      user = User.new(name: 'Test', date_of_birth: Date.new(1984, 3, 9))
      user.save
      
      user = User.find(user.id)
      assert_equal(user.date_of_birth.class, Date)
  end
end
