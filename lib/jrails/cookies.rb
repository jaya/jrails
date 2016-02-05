module Jrails::Cookies
  def cookies
    self.request.cookie_jar
  end
end