require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      template_path = "views/#{self.class.to_s.underscore}/#{template_name.to_s}.html.erb"
      template = File.read(template_path)
      content = ERB.new(template).result(binding)
      # <%= foo %>
      # binding.eval("foo")
      # binding looks at all the variables that are in scope and makes a binding instance
      # Then you can evaluate all the variables that were defined up until the binding
      # instance was instantiated. Then ERB.result will automatically evaluate all
      # the variables in binding. That's how the controller and the views instance variables
      # get linked with each other. See example below for binding:
      #  14:36 $ pry
      # [1] pry(main)> b = binding
      # => #<Binding:0x007ffabae00120>
      # [2] pry(main)> foo = "bar"
      # => "bar"
      # [3] pry(main)> b.eval("foo")
      # NameError: undefined local variable or method `foo' for main:Object
      # from (pry):1:in `__pry__'
      # [4] pry(main)> b2 = binding
      # => #<Binding:0x007ffabb9481e0>
      # [5] pry(main)> b2.eval("foo")
      # => "bar"
      # [6] pry(main)>
      render_content(content, "text/html")
    end
  end
end
