require 'test_helper'

class HomeTest < ActionDispatch::IntegrationTest
  test "get / return OK" do
    get '/'

    assert_equal 200, response.status
  end

  test "get / return text/plain content-type" do
    get '/'

    assert_equal 'text/plain', response.content_type
  end

  test "get /text return pi-pi-pi-pi" do
    get '/text'

    assert_equal 'pi-pi-pi-pi', response.body
  end

  test "get /redirect return redirect" do
    get '/redirect'

    assert_equal 302, response.status
  end

  test "get /redirect returns location" do
    get '/redirect'

    assert_equal 'http://www.google.com', response.location
  end

  test "get /json returns a json" do
    get '/json'

    assert_equal({ 'foo' => 'bar' }, JSON.parse(response.body))
    assert_equal 'application/json', response.content_type
  end

  test "get /jaya_header returns a custom header" do
    get '/jaya_header'

    assert_equal('inxame', response.headers['X-jaya'])
  end

  test "get /cookie returns a cookie" do
    get '/cookie'

    assert_equal('negresco', response.cookies['chocookie'])
  end

  test "get /flash renders flash" do
    get "/flash"

    assert_equal({"flashes"=>{"message"=>"flashman"}}, session[:flash])
  end
  
  test "get /not_modifed" do
    get "/not_modified"

    assert_equal(200, response.status)
    assert_equal('2000-10-20 10:20:12Z', response.headers['Last-Modified'])
  end
  
  test "get /not_modified new object" do
    date = Time.new(2000, 10, 20, 10, 20, 12).httpdate
    get "/not_modified", headers: { 'HTTP_IF_MODIFIED_SINCE' => date }
    
    assert_response(304, response.status)
  end
end
