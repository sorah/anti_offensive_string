$:.unshift File.expand_path('../../lib', __FILE__)
gem 'minitest'
require "minitest/autorun"
require 'rack/test'
require 'anti_offensive_string'

class DummyApp
  def initialize(*)
    @called = false
  end

  def called?
    @called
  end

  def call(env)
    @called = true
    [200, {"Content-Type" => "text/plain"}, [env['rack.input'] ? env['rack.input'].read : '']]
  end
end

class AntiOffensiveStringTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    @dummy_app = DummyApp.new
    @protector = AntiOffensiveString.new(@dummy_app)
  end

  def app
    @protector
  end

  def test_offensive_input
    post "/", "%D9%87 %D2%88%D2%88%D2%88"

    refute @dummy_app.called?
    assert_equal 400, last_response.status
  end

  def test_normal_input
    post "/", "hola"

    assert @dummy_app.called?
    assert_equal 200, last_response.status
    assert_equal 'hola', last_response.body
  end

  def test_offensive_query
    get "?offensive=%D9%87+%D2%88%D2%88%D2%88"

    refute @dummy_app.called?
    assert_equal 400, last_response.status
  end

  def test_normal_params
    get "?normal=hola"

    assert @dummy_app.called?
    assert_equal 200, last_response.status
  end

  def test_error_response
    AntiOffensiveString.error_response = [400, {}, "handled"]
    post "/", "%D9%87 %D2%88%D2%88%D2%88"

    refute @dummy_app.called?
    assert_equal 400, last_response.status
    assert_equal "handled", last_response.body
  ensure
    AntiOffensiveString.handler = AntiOffensiveString::DEFAULT_HANDLER
  end

  def test_handler
    AntiOffensiveString.on_offensive_request do |env|
      [400, {}, "handled2#{env["PATH_INFO"]}"]
    end

    post "/", "%D9%87 %D2%88%D2%88%D2%88"

    refute @dummy_app.called?
    assert_equal 400, last_response.status
    assert_equal "handled2/", last_response.body
  ensure
    AntiOffensiveString.handler = AntiOffensiveString::DEFAULT_HANDLER
  end
end
