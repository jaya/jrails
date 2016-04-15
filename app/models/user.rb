class User
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::Conversion
    include ActiveModel::Validations
    
    validates :name, presence: true
    
    def persisted?
        false
    end

    attr_accessor :id, :name, :age, :date_of_birth
    
    def self.map(fields)
        @@mapping ||= {} 
        @@mapping[fields.keys.first] = fields[fields.keys.first]
    end
    
    map({date_of_birth: :date, age: :fixnum})
    
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
        deserialize(JSON.parse(data).symbolize_keys) if data.present?
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
