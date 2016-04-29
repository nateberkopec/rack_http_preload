require 'test_helper'
require "rack"
require "mime/types"

class RackHttpPreloadTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RackHttpPreload::VERSION
  end

  def test_it_adds_a_link_header
    result = MyTestRackApp.new.call({})

    expected_headers = "<application.js>; rel=preload; as=script"
    assert_equal expected_headers, result[1]["Link"]
  end

  def test_deals_with_options
    result = MyTestRackAppWithOptions.new().call({})

    expected_headers = "<assets/font.woff2>; rel=preload; as=font; crossorigin; type='font/woff2'"
    assert_equal expected_headers, result[1]["Link"]
  end

  def test_multiple_links
    result = MyTestRackAppWithMultiLinks.new().call({})

    expected_headers = "<application.js>; rel=preload; as=script, <application.css>; rel=preload; as=style"
    assert_equal expected_headers, result[1]["Link"]
  end

  def test_rack_app_with_mime_guessing
    result = MyTestRackAppWithMimeGuessing.new().call({})

    expected_headers = "<application.js>; rel=preload; as=script, <application.woff2>; rel=preload; as=font; type='application/font-woff'"
    assert_equal expected_headers, result[1]["Link"]
  end
end

class MyTestRackApp
  include RackHttpPreload
  attr_accessor :response

  def initialize
    self.response = Rack::Response.new("Hello World!", 200, {})
  end

  def call env
    http_preload "application.js", as: :script
    response.finish
  end
end

class MyTestRackAppWithOptions < MyTestRackApp
  def call env
    http_preload "assets/font.woff2", as: :font, crossorigin: true, push: false, type: "font/woff2"
    response.finish
  end
end

class MyTestRackAppWithMultiLinks < MyTestRackApp
  def call env
    http_preload "application.js", as: :script
    http_preload "application.css", as: :style
    response.finish
  end
end

class MyTestRackAppWithMimeGuessing < MyTestRackApp
  def call env
    http_preload "application.js"
    http_preload "application.woff2"
    response.finish
  end
end
