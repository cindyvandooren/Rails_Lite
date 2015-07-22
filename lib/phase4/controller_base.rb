require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    # In this class we use our Session module to create a new session
    # and then add content to our session when we render or redirect.
    
    attr_accessor :session

    def redirect_to(url)
      super
      @session.store_session(res)
    end

    def render_content(content, content_type)
      super
      @session.store_session(res)
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(req)
    end
  end
end
