module Jrails::Head
  def head(status, options={})
    self.status = status
    self.content_type = options.delete(:content_type)
    options.each { |key, value| self.headers[key] = value }
  end
end