require 'json'
require 'webrick'
require 'byebug'

module Phase4
  class Session
    # In this class we set everything up so that we can add session_tokens
    # to our session. This class makes a Session object, that will allow
    # us to store session_tokens and other cookie information in there.

    # find the cookie for this app
    # deserialize the cookie into a hash
    attr_accessor :session_content

    def initialize(req)
      # req refers to a WEBrick::HTTPRequest that has a #cookies method
      # req.cookies is an array of cookies, cookies are Cookie objects
      # (hashes with name and value as keys, value has a hash with
      # authenticity token, flash, ... as keys)
      cookie = req.cookies.find { |c| c.name == "_rails_lite_app" }
      @session_content = cookie ? JSON.parse(cookie.value) : {}
    end

    def [](key)
      @session_content[key]
    end

    def []=(key, val)
      @session_content[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies

    def store_session(res)
      res.cookies << WEBrick::Cookie.new("_rails_lite_app", session_content.to_json)
    end
  end
end
