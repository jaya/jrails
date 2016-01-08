require 'jrails/head'
require 'jrails/redirecting'

class HomeController < ActionController::Metal
  include Jrails::Head
  include Jrails::Redirecting
  include AbstractController::Rendering
  include ActionController::Rendering
  include ActionController::Renderers::All
  include ActionController::Helpers
  include ActionController::Cookies
  include ActionController::Flash

  def index
    head :ok, content_type: 'text/plain'
  end
  
  def text
    render plain: "pi-pi-pi-pi"
  end

  def redirect
    redirect_to 'http://www.google.com'
  end

  def json
    render json: { foo: 'bar' }
  end

  def jaya_header
    head :ok, { 'X-jaya' => 'inxame' }
  end

  def cookie
    cookies[:chocookie] = 'negresco'
  end

  def flashman
    flash[:message] = 'flashman'
  end
end
