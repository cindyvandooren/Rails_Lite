require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative 'session'
require_relative 'params'

class ControllerBase
  attr_accessor :already_built_response
  attr_reader :params, :req, :res

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = Params.new(req, route_params)
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
      @res["Location"] = url
      @res.status = 302
      @already_built_response = true
      session.store_session(@res)
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
      session.store_session(@res)
      nil
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

  def session
    @session ||= Session.new(@req)
  end

  # Used with router to call controller action name
  def invoke_action(action_name)
    self.send(action_name)
    unless already_built_response?
      render(action_name)
    end

    nil
  end
end
