class User
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::Conversion
    include ActiveModel::Validations
    
    validates :name, presence: true
    
    def persisted?
        false
    end

    attr_accessor :id, :name
    
    def initialize(attributes = {})
        self.id = attributes[:id]
        self.name = attributes[:name]
    end
    
    def save
        if valid?
            redis = Redis.new(port: 6379)
            self.id = SecureRandom.uuid
            redis.set("user_#{id}", self.to_json)
        end
    end
    
    def to_param
        id.to_s
    end
    
    def self.all
        redis = Redis.new(port: 6379)
        redis.keys.map { |key| load(key) }
    end
    
    def self.find(id)
        load("user_#{id}")
    end
    
    def self.load(key)
        redis = Redis.new(port: 6379)
        data = redis.get(key)
        User.new(JSON.parse(data).symbolize_keys) if data.present?
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
