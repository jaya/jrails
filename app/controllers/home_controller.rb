require 'jrails/head'
require 'jrails/redirecting'
require 'jrails/rendering'
require 'jrails/cookies'
require 'jrails/flash'
require 'jrails/conditional_get'
require 'jrails/jaya_error'
require 'jrails/rescue_from'

class HomeController < ActionController::Metal
  # include ActionController::Rescue
  # include Jrails::RescueFrom
  include Jrails::Head
  include Jrails::Redirecting
  include Jrails::Rendering
  include Jrails::Cookies
  include Jrails::Flash
  include Jrails::ConditionalGet

  def process_action(method_name, *args)
    super
  rescue => e
    handle_error(e)
  end
  
  def self.rescue_from(exception, hash)
    @@rescue_options = hash.merge(exception: exception)
  end
  
  def handle_error(exception)
    e = @@rescue_options[:exception].is_a?(String) ?  @@rescue_options[:exception].constantize : @@rescue_options[:exception]
    public_send(@@rescue_options[:with], exception) if exception.is_a?(e)
  end

  rescue_from 'StandardError', with: :show_errors

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
  
  def not_modified
    # byebug
    if stale?(last_modified: Time.parse('2000-10-20 10:20:10Z'))
      head :ok, content_type: 'text/plain', 'Last-Modified' => '2000-10-20 10:20:12Z'
    end
  end
  
  def rescue_from_action
    raise 'jaya'
  end
  
  def show_errors(exception)
    head :bad_request
  end
end
