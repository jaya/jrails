module ActiveRedis
    class Base
        def persisted?
            false
        end
        
        def self.map(fields)
            @@mapping ||= {}
            fields.each do |k , v| 
                self.send(:attr_accessor, k)
                @@mapping[k] = v
            end
        end
        
        def save
            if valid?
                redis = Redis.new(port: 6379)
                self.id = SecureRandom.uuid
                redis.set("#{self.class.name}_#{id}", self.to_json)
            end
        end
        
        def self.all
            redis = Redis.new(port: 6379)
            redis.keys.map { |key| load(key) }
        end
        
        def self.find(id)
            load("#{name}_#{id}")
        end
        
        def to_param
            id.to_s
        end
        
        def ==(other_object)
            self.id == other_object.id && \
            self.class == other_object.class
        end

        private

        def self.load(key)
            redis = Redis.new(port: 6379)
            data = redis.get(key)
            deserialize(JSON.parse(data).symbolize_keys) if data.present?
        end
    end
end