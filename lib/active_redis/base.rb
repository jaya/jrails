module ActiveRedis
    class Base
        def persisted?
            false
        end
        
        def save
            if valid?
                redis = Redis.new(port: 6379)
                self.id = SecureRandom.uuid
                redis.set("#{self.class.name}_#{id}", self.to_json(only: @@mapping.keys.map(&:to_s)))
            end
        end
        
        def to_param
            id.to_s
        end
        
        def ==(other_object)
            self.id == other_object.id && \
            self.class == other_object.class
        end
        
        class << self
            def map(fields)
                @@mapping ||= {}
                fields.each do |k , v| 
                    self.send(:attr_accessor, k)
                    @@mapping[k] = v
                end
            end
            
            def all
                redis = Redis.new(port: 6379)
                redis.keys.map { |key| load(key) }
            end
            
            def find(id)
                load("#{name}_#{id}")
            end
            
            private
        
            def load(key)
                redis = Redis.new(port: 6379)
                data = redis.get(key)
                deserialize(JSON.parse(data).symbolize_keys) if data.present?
            end
        
            def delete_all
                redis = Redis.new(port: 6379)
                redis.flushdb
            end
            
            def deserialize(attributes)
                self.new.tap do |object|
                    attributes.each do |k, v|
                        if @@mapping[k] == :date
                            object.send("#{k}=", Date.parse(v)) if v.present?
                        else
                            object.send("#{k}=", v)
                        end
                    end
                end
            end
        end
    end
end