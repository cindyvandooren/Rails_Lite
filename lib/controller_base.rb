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

  # Set response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "Already built a response"
    else
      @res["Location"]=(url)
      @res.status=(302)
      @already_built_response = true
    end
  end

  # Populate the response with content and avoid double rendering
  def render_content(content, content_type)
    if already_built_response?
      raise "Already built a response"
    else
      @res.content_type = content_type
      @res.body = content
      @already_built_response = true
    end
  end

  # Use of ERB and binding to evaluate templates
  # Pass the rendered html to render_content
  def render(template_name)
    template_path = "views/#{self.class.to_s.underscore}/#{template_name.to_s}.html.erb"
    template = File.read(template_path)
    content = ERB.new(template).result(binding)
    render_content(content, "text/html")
  end
end
