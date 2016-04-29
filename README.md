# RackHttpPreload

Requires Ruby 2.0+.

`rack_http_preload` is only compatible with Rack apps that provide a `response` object. This `response` object should be compatible with `Rack::Response`, namely it should provide `response.headers=`.

```ruby
require "rack"

class MyTestRackApp
  include RackHttpPreload
  attr_accessor :response

  def call(env)
    self.response = Rack::Response.new("Hello World!", 200, {})
    # If MIME::Types is available, this gem guesses the appropriate `as` and `type`
    http_preload "application.js"
    response.finish
  end

  # "Link"=>"<application.js>; rel=preload; as=script"
end
```
