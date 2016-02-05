module Jrails::Flash
  def flash
    self.request.flash
  end
end