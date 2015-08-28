require 'json'
require 'webrick'

class Session
  # This class will allow us to store session_tokens and other cookies
  attr_accessor :session_content

  # Find the cookie for this app and deserialize it into a hash
  def initialize(req)
    cookie = req.cookies.find { |c| c.name == "_rails_lite_app" }
    @session_content = cookie ? JSON.parse(cookie.value) : {}
  end

  def [](key)
    @session_content[key]
  end

  def []=(key, val)
    @session_content[key] = val
  end

  # Serialize the cookie hash into json and add cookie to response
  def store_session(res)
    res.cookies << WEBrick::Cookie.new(
      "_rails_lite_app",
      session_content.to_json
    )
  end
end
