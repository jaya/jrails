require_relative '../../lib/active_redis/base'

class User < ActiveRedis::Base
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::Conversion
    include ActiveModel::Validations

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
    
    def self.deserialize(attributes)
        user = User.new
        user.id = attributes[:id]
        user.name = attributes[:name]
        user.age = attributes[:age]
        if @@mapping[:date_of_birth] == :date
          user.date_of_birth = Date.parse(attributes[:date_of_birth]) if attributes[:date_of_birth].present?
        end
        user
    end
    
    def to_param
        id.to_s
    end
    
    def ==(other_user)
        self.id == other_user.id && \
        self.class == other_user.class
    end
    
    def self.delete_all
        redis = Redis.new(port: 6379)
        redis.flushdb
    end
end
