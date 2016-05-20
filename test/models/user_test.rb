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
      assert_equal(Date, user.date_of_birth.class)
  end
  
  test 'test delete key' do
    user = User.new(name: 'Test')
    user.save
    user_id = user.id
    user = User.find(user_id)
    user.destroy
    deleted_user = User.find(user_id)
    assert_equal(deleted_user, nil)
  end
  
  test 'test update user' do
      user = User.new(name: 'Test')
      user.save
      
      user = User.find(user.id)
      user.update(name: 'Test 2')
      
      user_updated = User.find(user.id)
      assert_equal('Test 2', user_updated.name)
  end
  
  test '.where' do
      User.delete_all
      first_user = User.new(name: 'Test', date_of_birth: Date.new(1984, 3, 9))
      first_user.save
      second_user = User.new(name: 'Test 2', date_of_birth: Date.new(1984, 3, 9))
      second_user.save
      third_user = User.new(name: 'Test 3', date_of_birth: Date.new(1984, 4, 10))
      third_user.save
      
      users = User.where(date_of_birth: Date.new(1984, 3, 9))

      assert_equal(true, users.include?(first_user))
      assert_equal(true, users.include?(second_user))
      assert_equal(false, users.include?(third_user))
  end
  
  test '.count' do
    User.delete_all

    User.new(name: 'Test', date_of_birth: Date.new(1983, 3, 9)).save
    User.new(name: 'Test 2', date_of_birth: Date.new(1984, 3, 9)).save

    assert_equal(2, User.count)
  end
  
  test '.order' do
    User.delete_all
    first_user = User.new(name: 'Test', date_of_birth: Date.new(1983, 3, 9))
    first_user.save
    second_user = User.new(name: 'Test 2', date_of_birth: Date.new(1984, 3, 9))
    second_user.save

    users = User.order(:name)

    assert_equal([first_user, second_user], users)
  end
end
