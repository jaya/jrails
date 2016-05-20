require_relative '../../lib/active_redis/base'

class User < ActiveRedis::Base
    validates :name, presence: true
    
    # map({age: :fixnum, date_of_birth: :date, id: :string, name: :string})
   
    map date_of_birth: :date
    map age: :fixnum
    map id: :string
    map name: :string
   
    def initialize(attributes = {})
      self.id = attributes[:id]
      self.name = attributes[:name]
      self.age = attributes[:age]
      self.date_of_birth = attributes[:date_of_birth]
    end
end
