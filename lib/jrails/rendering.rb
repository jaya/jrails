module Jrails::Rendering
  def render(options)
    self.response.body = options[:plain] if options.key?(:plain)
    if options.key?(:json)
      self.content_type = "application/json"
      self.response.body = options[:json].to_json 
    end
  end
end