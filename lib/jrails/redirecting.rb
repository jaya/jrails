module Jrails::Redirecting
  def redirect_to(options = {}, respose_status = {})
    self.status = 302
    self.location = options
  end
end