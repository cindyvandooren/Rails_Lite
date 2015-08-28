module Phase2
  class ControllerBase
    attr_accessor :already_built_response, :req, :res

    def initialize(req, res, route_params = {})
      @req = req
      @res = res
      @already_built_response = false
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @already_built_response
    end

    # Set the response status code and header
    def redirect_to(url)
      if already_built_response?
        raise "Already built a response"
      else
        @res["location"]=(url)
        @res.status=(302)
        @already_built_response = true
      end
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, content_type)
      if already_built_response?
        raise "Already built a response"
      else
        @res.content_type=(content_type)
        @res.body = content
        @already_built_response = true
      end
    end
  end
end
